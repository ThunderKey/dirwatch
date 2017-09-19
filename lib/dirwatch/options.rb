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



        opts.on('-d', '--daemonize', 'Run the programm as a daemon') do
          options.daemonize = true
        end

        opts.on('-h', '--help', 'Show this help') do
          puts opts
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

    def initialize directory: nil, daemonize: nil
      raise 'The directory is required' unless directory
      @directory = directory
      @daemonize = !!daemonize
    end
  end
end
