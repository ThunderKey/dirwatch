require 'yaml'
require_relative 'dirwatch/options'
require_relative 'dirwatch/errors'

module Dirwatch
  class << self
    def run_from_args args
      options = Options.from_args(args)
      case options.method
      when :exit
        return
      when :watch
        watch options
      when :init
        init options
      else
        raise "Undefined method #{options.method}"
      end
    end

    private

    def watch options
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

    def init options
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
