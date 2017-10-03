require 'yaml'
require_relative 'dirwatch/options'
require_relative 'dirwatch/errors'

module Dirwatch
  def self.run_from_args args
    options = Options.from_args(args)
    case options.method
    when :exit
    when :watch
      require_relative 'dirwatch/watcher'

      watcher = Watcher.new options
      watcher.start

      begin
        sleep
      rescue Interrupt
      ensure
        puts "shutting down..."
        watcher.stop
      end
    when :init
      require_relative 'dirwatch/templates'

      hash = options.to_h
      if hash.delete :list
        Templates.list hash
      else
        Templates.create hash
      end
    else; raise "Undefined method #{options.method}"
    end
  end
end
