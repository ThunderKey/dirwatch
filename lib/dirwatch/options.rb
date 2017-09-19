module Dirwatch
  class Options
    def self.from_args args
      require 'optparse'
      require 'ostruct'

      show_help = false
      options = OpenStruct.new
      options.directory = './'
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} [options] [directory]"

        opts.on '-v', '--[no-]verbose', 'Print additional information' do |verbose|
          options.verbose = verbose
        end

        opts.on '-d', '--[no-]daemonize', 'Run the programm as a daemon' do |daemonize|
          options.daemonize = daemonize
        end

        opts.on_tail '-h', '--help', 'Show this help' do
          puts opts
          exit
        end

        opts.on_tail '--version', 'Show the version' do
          require 'dirwatch/version'
          puts "dirwatch #{Dirwatch::VERSION}"
          exit
        end
      end
      parser.parse! args

      unless args.empty?
        if args.size > 1
          puts 'Too many arguments'
          puts parser
          exit
        end
        options.directory = args.first
      end

      new options.to_h
    end

    attr_reader :directory, :daemonize

    def initialize directory:, daemonize: false, verbose: false
      raise 'The directory is required' unless directory
      @directory = directory
      @daemonize = daemonize
      @verbose = verbose
    end
  end
end
