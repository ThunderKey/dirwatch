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

      begin
        sleep
      rescue Interrupt
        raise
      ensure
        stop_watcher
      end
    end

    def stop_watcher
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
      exit status if status
    rescue Dirwatch::FileNotFoundError => e
      puts "Could not find the file #{e.filename.inspect}"
      exit 1
    end

    private

    def stop_watcher
      puts 'shutting down...'
      super
    end
  end
end
