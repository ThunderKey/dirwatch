module Dirwatch
  class Watcher
    def self.from_args args
      new Options.from_args(args)
    end

    attr_reader :options

    def initialize options
      @options = options
      @settings = Settings.from_options @options
    end

    def start
      raise 'already started' if @threads
      Thread.abort_on_exception = true
      @threads = []
      @stop = false
      @settings.by_interval do |interval, watch_settings|
        @threads << Thread.new do
          change_times = []
          loop do
            break if @stop
            watch_settings.each.with_index do |ws, i|
              change_time = ws.files.max_by {|f| File.ctime f }
              if change_time != change_times[i]
                change_times[i] = change_time
                puts 'exec_scripts'
                ws.exec_scripts
              end
            end

            break if @stop
            sleep interval
          end
        end
      end
      @settings.watch_settings.each {|k,ws| puts "Watching #{k}" }
      if options.daemonize
        puts "running in the background..."
        Process.daemon true, true
      end
    end

    def stop
      raise 'not started' unless @threads
      @stop = true
      @threads.each {|t| t.join }
    end

    def files
      Dir[File.join options.directory, '**', options.file_match]
    end
  end
end
