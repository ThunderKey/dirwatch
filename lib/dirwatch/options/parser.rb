require 'optparse'
require 'ostruct'

module Dirwatch
  class Options
    class Parser
      COMMAND_NAME = 'dirwatch'.freeze

      def self.from_args args
        if args.first == 'init'
          args.shift
          InitParser.new [WatchParser.command_name]
        else
          WatchParser.new [InitParser.command_name]
        end
      end

      attr_reader :options

      def initialize alternatives
        @alternatives = alternatives
      end

      def parse! args
        build.parse! args
      end

      def command_name
        self.class.command_name
      end

      def action
        self.class.action
      end

      private

      def build
        @options = OpenStruct.new
        @parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{command_name}"

          opts.on '-v', '--[no-]verbose', 'Print additional information' do |verbose|
            options.verbose = verbose
          end

          yield opts if block_given?

          opts.on '-h', '--help', 'Show this help message' do
            puts opts
            throw :exit, 0
          end

          add_alternatives opts, @alternatives
          add_version opts
        end
      end

      def add_alternatives opts, alternatives
        return if alternatives.empty?
        opts.separator ''
        opts.separator 'Other Methods:'
        alternatives.each {|a| opts.separator "    #{a}" }
      end

      def add_version opts
        require 'dirwatch/version'
        opts.separator ''
        opts.separator "Version: #{::Dirwatch::VERSION}"
      end

      def limit_number_of_args limit, args
        return if args.size <= limit
        warn "Unknown arguments: #{args.map(&:inspect).join(', ')}"
        warn "Allowed optional arguments: #{limit}"
        puts @parser
        throw :exit, 1
      end
    end

    class WatchParser < Parser
      @command_name = "#{Parser::COMMAND_NAME} [options] [directory|file]"
      @action = :watch
      class << self
        attr_reader :command_name, :action
      end

      def parse! args
        super
        limit_number_of_args 1, args
        options.directory = args.shift if args.any?
      end

      private

      def build
        super do |opts|
          opts.on '-d', '--[no-]daemonize', 'Run the programm as a daemon' do |daemonize|
            options.daemonize = daemonize
          end

          opts.on '--once', 'Run the programm only once' do |once|
            options.once = once
          end

          opts.on '--version', 'Show the version' do
            require 'dirwatch/version'
            puts "dirwatch #{Dirwatch::VERSION}"
            throw :exit, 0
          end
        end
      end
    end

    class InitParser < Parser
      @command_name = "#{Parser::COMMAND_NAME} init [options] [template]"
      @action = :init
      class << self
        attr_reader :command_name, :action
      end

      def parse! args
        super
        limit_number_of_args 1, args
        options.template = args.shift if args.any?
      end

      private

      def build
        super do |opts|
          opts.on '-l', '--[no-]list', 'List all available templates' do |list|
            options.list = list
          end

          opts.on '-f', '--[no-]force', 'Overwrite the .dirwatch.yml if it exists' do |force|
            options.force = force
          end

          opts.on '--os OS', [:windows, :linux, :mac],
            'Set the operating system to use. Otherwise it tries to detect it.' do |os|
            options.operating_system = os
          end
        end
      end
    end
  end
end
