require_relative 'settings'

unless Process.respond_to? :daemon
  module Process
    def self.daemon _nochdir, _noclose
      raise Dirwatch::DaemonizeNotSupportedError
    end
  end
end

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
        watch_settings.each {|ws| puts "Watching #{ws}" } if @options.verbose
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
      until @stop
        watch watch_settings, change_times

        break if @stop || options.once
        sleep interval
      end
    end

    def watch watch_settings, change_times
      watch_settings.each.with_index do |ws, i|
        change_time = ws.files_changed_at
        next if change_time == change_times[i]
        puts "Changed: #{ws.key}" if options.verbose
        change_times[i] = change_time
        ws.exec_scripts options.verbose
      end
    end
  end
end
