require_relative 'settings'

module Dirwatch
  class Watcher
    attr_reader :options
    attr_reader :settings

    def initialize options
      @options = options
      @settings = Settings.from_options @options

      return unless options.daemonize
      Process.daemon true, true
      puts "running in the background... [#{Process.pid}]"
    end

    def start
      raise 'already started' if @threads
      @threads = []
      @stop = false

      Thread.abort_on_exception = true
      @settings.by_interval do |interval, watch_settings|
        watch_settings.each {|ws| puts "Watching #{ws}" }
        @threads << Thread.new do
          run interval, watch_settings
        end
      end
    end

    def wait_for_stop
      @threads.each(&:join)
    end

    def stop
      raise 'not started' unless @threads
      @stop = true
      wait_for_stop
    end

    def files
      Dir[File.join options.directory, '**', options.file_match]
    end

    private

    def run interval, watch_settings
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
