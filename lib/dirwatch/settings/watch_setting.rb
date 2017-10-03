require 'English' # for CHILD_STATUS

module Dirwatch
  class Settings
    class WatchSetting
      attr_reader :interval, :scripts

      def initialize directory:, file_match:, interval:, scripts:
        self.directory = directory
        self.file_match = file_match
        self.interval = interval
        self.scripts = scripts
      end

      def files_path
        File.join @directory, '**', @file_match
      end

      def files
        Dir[files_path]
      end

      def exec_scripts
        @scripts.each do |script|
          if script =~ / & *\z/
            system script
          else
            output = `#{script}`
            unless $CHILD_STATUS.successful?
              raise "The command \"#{script}\" failed with: #{output}"
            end
          end
        end
      end

      def to_s
        variables = [:files_path, :interval, :scripts].map {|v| "#{v}=#{send(v).inspect}" }
        "#<#{self.class} #{variables.join ' '}>"
      end

      private

      def directory= directory
        @directory = directory
        raise 'directory must be set' if @directory.nil? || @directory.empty?
      end

      def file_match= file_match
        @file_match = file_match
        raise 'file_match must be set' if @file_match.nil? || @file_match.empty?
      end

      def interval= interval
        @interval = interval || raise('interval must be set')
        raise 'the interval must be greater than 0' if @interval <= 0
      end

      def scripts= scripts
        if scripts.is_a? String
          scripts = [scripts]
        elsif !scripts.is_a?(Array) || scripts.any? {|s| !s.is_a? String }
          raise "Script needs to be a string or a list of strings: #{scripts.inspect}"
        end
        @scripts = scripts
      end
    end
  end
end
