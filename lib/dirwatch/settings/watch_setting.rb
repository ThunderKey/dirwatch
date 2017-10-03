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
            output = %x(#{script})
            raise "The command \"#{script}\" failed with: #{output}" if $? != 0
          end
        end
      end

      def to_s
        "#<#{self.class} files_path=#{files_path} interval=#{interval.inspect} scripts=#{scripts.inspect}>"
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
          raise "the scripts need to be either one string or a list of strings. Not: #{scripts.insepct}"
        end
        @scripts = scripts
      end
    end
  end
end
