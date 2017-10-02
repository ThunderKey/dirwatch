module Dirwatch
  module OsFetcher
    @@available = [
      WINDOWS = :windows,
      MAC = :mac,
      LINUX = :linux,
    ]

    def self.available
      @@available
    end

    def self.fetch
      if windows?
        WINDOWS
      elsif mac?
        MAC
      elsif linux?
        LINUX
      else
        raise "Unknown operating system: #{RUBY_PLATFORM}"
      end
    end

    def self.windows?
      /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
    end

    def self.mac?
      /darwin/ =~ RUBY_PLATFORM
    end

    def self.unix?
      !windows?
    end

    def self.linux?
      unix? and !mac?
    end
  end
end
