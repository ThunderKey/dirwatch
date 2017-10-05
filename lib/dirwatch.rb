require 'yaml'
require_relative 'dirwatch/options'
require_relative 'dirwatch/errors'

module Dirwatch
  class << self
    def run_from_args args
      options = Options.from_args(args)
      send "run_#{options.method}", options
    end

    private

    def run_exit options; end

    def run_watch options
      require_relative 'dirwatch/watcher'

      watcher = Watcher.new options
      watcher.start

      begin
        sleep
      rescue Interrupt
        raise
      ensure
        puts 'shutting down...'
        watcher.stop
      end
    end

    def run_init options
      require_relative 'dirwatch/templates'

      hash = options.to_h
      if hash.delete :list
        Templates.list hash
      else
        Templates.create hash
      end
    end
  end
end
