require_relative '../dirwatch'

module Dirwatch
  class Executor
    def run args
      options = Options.from_args(args)
      send "run_#{options.action}", options
      nil
    end

    private

    def run_exit options; end

    def run_watch options
      require_relative 'watcher'

      watcher = Watcher.new options
      watcher.start
      puts 'Watching files...'

      begin
        watcher.wait_for_stop
      rescue Interrupt
        interrupted
      ensure
        stop_watcher watcher
      end
    end

    def interrupted() end

    def stop_watcher watcher
      watcher.stop
    end

    def run_init options
      require_relative 'templates'

      hash = options.to_h
      if hash.delete :list
        Templates.list hash
      else
        Templates.create hash
      end
    end
  end

  class Console < Executor
    def run args
      status = catch :exit do
        super
      end
      exit status || 0
    rescue Dirwatch::UserFriendlyError => e
      warn e.user_friendly_message
      exit 1
    end

    private

    def stop_watcher watcher
      puts 'shutting down...'
      super
    end

    def interuppted
      exit 0
    end
  end
end
