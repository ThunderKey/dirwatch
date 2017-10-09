require_relative 'os_fetcher'
require_relative 'options/parser'

module Dirwatch
  class Options
    def self.from_args args
      parser = Parser.from_args args
      parser.parse! args

      new parser.action, parser.options.to_h
    end

    attr_reader :action, :options

    def initialize action, options
      @action = action.to_sym
      @options = send "#{@action}_options", options
    end

    def to_h
      @options
    end

    def method_missing m, *args, &block
      return @options[m] if @options && @options.key?(m)
      super
    end

    def respond_to_missing? m
      (@options && @options.key?(m)) || super
    end

    private

    def exit_options _options
      {}
    end

    def watch_options options
      {
        directory: options.fetch(:directory, './'),
        daemonize: options.fetch(:daemonize, false),
        verbose:   options.fetch(:verbose, false),
      }
    end

    def init_options options
      opts = {
        template:         options.fetch(:template, nil),
        list:             options.fetch(:list, false),
        operating_system: options.fetch(:operating_system, OsFetcher.fetch),
        verbose:          options.fetch(:verbose, false),
        force:            options.fetch(:force, false),
      }
      if opts[:list]
        opts.delete :template
        opts.delete :force
      end
      opts
    end
  end
end
