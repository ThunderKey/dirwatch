require 'English' # for CHILD_STATUS

module Dirwatch
  class Settings
    class WatchSetting
      attr_reader :key, :directory, :file_match, :interval, :scripts

      def initialize key, directory:, file_match:, interval:, scripts:
        self.key = key
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

      def exec_scripts verbose
        @scripts.each do |script|
          if script =~ / & *\z/
            puts "  Call #{script.inspect} in background" if verbose
            system script
          else
            puts "  Call #{script.inspect} in foreground" if verbose
            output = `#{script}`
            unless $CHILD_STATUS.success?
              raise "The command \"#{script}\" failed with: #{output}"
            end
          end
        end
      end

      def to_h
        {
          directory:  directory,
          file_match: file_match,
          interval:   interval,
          scripts:    scripts,
        }
      end

      def to_s
        "#<#{self.class} #{key}: #{to_h.map {|k, v| "#{k}=#{v.inspect}" }.join ' '}>"
      end

      private

      def key= key
        @key = key
        raise InvalidValueError, 'key must be set' if @key.blank?
      end

      def directory= directory
        @directory = directory
        raise InvalidValueError, 'directory must be set' if @directory.blank?
      end

      def file_match= file_match
        @file_match = file_match
        raise InvalidValueError, 'file_match must be set' if @file_match.blank?
      end

      def interval= interval
        @interval = interval || raise(InvalidValueError, 'interval must be set')
        raise InvalidValueError, 'the interval must be greater than 0' if @interval <= 0
      end

      def scripts= scripts
        if scripts.is_a? String
          scripts = [scripts]
        elsif !scripts.is_a?(Array) || !scripts.all? {|s| s.is_a?(String) && s.present? }
          raise InvalidValueError,
            "Script needs to be a string or a list of strings: #{scripts.inspect}"
        end
        @scripts = scripts
      end
    end
  end
end
