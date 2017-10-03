require 'optparse'
require 'ostruct'
require_relative 'os_fetcher'

module Dirwatch
  class Options
    @@command_name = 'dirwatch'

    def self.build_parser cmd, options, alternatives, verbose: true, help: true, &block
      OptionParser.new do |opts|
        opts.banner = "Usage: #{cmd}"

        if verbose
          opts.on '-v', '--[no-]verbose', 'Print additional information' do |verbose|
            options.verbose = verbose
          end
        end

        block.call opts

        if help
          opts.on '-h', '--help', 'Show this help message' do
            puts opts
            options.exit = true
          end
        end

        if alternatives.any?
          opts.separator ''
          opts.separator 'Other Methods:'
          alternatives.each {|a| opts.separator "    #{a}" }
        end
      end
    end

    def self.build_watch_parser cmd, options, alternatives
      build_parser(cmd, options, alternatives) do |opts|
        opts.on '-d', '--[no-]daemonize', 'Run the programm as a daemon' do |daemonize|
          options.daemonize = daemonize
        end

        opts.on '--version', 'Show the version' do
          require 'dirwatch/version'
          puts "dirwatch #{Dirwatch::VERSION}"
          options.exit = true
        end
      end
    end

    def self.build_init_parser cmd, options, alternatives
      build_parser(cmd, options, alternatives) do |opts|
        opts.on '-l', '--[no-]list', 'List all available templates' do |list|
          options.list = list
        end

        opts.on '-f', '--[no-]force', 'Overwrite the dirwatch.yml if it already exists' do |force|
          options.force = force
        end

        opts.on '--os OS', [:windows, :linux, :mac], 'Set the operating system to use. Otherwise it tries to detect it.' do |operating_system|
          options.operating_system = operating_system
        end
      end
    end

    def self.from_args args
      show_help = false
      options = OpenStruct.new
      watch_command = "#{@@command_name} [options] [directory]"
      init_command = "#{@@command_name} init [options] [template]"

      watch_parser = build_watch_parser watch_command, options, [init_command]
      init_parser = build_init_parser    init_command,    options, [watch_command]

      method = nil
      parser = if args.first == 'init'
        args.shift
        method = :init
        init_parser
      else
        method = :watch
        watch_parser
      end
      parser.parse! args

      if options.exit
        method = :exit
        options.delete_field :exit
      elsif args.any?
        if args.size > 1
          $stderr.puts "Unknown arguments: #{args.map(&:inspect).join(', ')}"
          puts parser
          method = :exit
        end
        case method
        when :exit
        when :watch; options.directory = args.first
        when :init;  options.template  = args.first
        else; raise "Unknown method #{method.inspect}"
        end
      end

      new method, options.to_h
    end

    attr_reader :method, :options

    def initialize method, directory: nil, daemonize: false, verbose: false, list: false, operating_system: nil, template: nil, force: false
      @method = method.to_sym
      @options = case @method
      when :exit
        {}
      when :watch
        {
          directory: directory || './',
          daemonize: daemonize,
          verbose:   verbose,
        }
      when :init
        opts = {
          template:         template,
          list:             list,
          operating_system: operating_system || OsFetcher.fetch,
          verbose:          verbose,
          force:            force,
        }
        if list
          opts.delete :template
          opts.delete :force
        end
        opts
      else
        raise "Unknown method #{method.inspect}"
      end
    end

    def to_h
      @options
    end

    def method_missing m, *args, &block
      if @options&.has_key? m
        @options[m]
      else
        super
      end
    end
  end
end
