module Dirwatch
  class Watcher
    def self.from_args args
      new Options.from_args(args)
    end

    attr_reader :options

    def initialize options
      @options = options
      @settings = Settings.from_options @options

      if options.daemonize
        Process.daemon true, true
        puts "running in the background... [#{Process.pid}]"
      end
    end

    def start
      raise 'already started' if @threads
      @threads = []
      @stop = false

      Thread.abort_on_exception = true
      @settings.by_interval do |interval, watch_settings|
        watch_settings.each {|ws| puts "Watching #{ws}" }
        @threads << Thread.new do
          change_times = []
          loop do
            break if @stop
            watch_settings.each.with_index do |ws, i|
              change_time = ws.files.map {|f| File.ctime f }.max
              if change_time != change_times[i]
                change_times[i] = change_time
                ws.exec_scripts
              end
            end

            break if @stop
            sleep interval
          end
        end
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
