require 'rbconfig'

module Dirwatch
  module OsFetcher
    AVAILABLE = [
      WINDOWS = :windows,
      MAC     = :mac,
      LINUX   = :linux,
    ].freeze

    class << self
      def operating_system
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc|win32|dos/
          WINDOWS
        when /darwin|mac os/
          MAC
        when /linux/
          LINUX
        else
          raise OsNotSupportedError.new host_os, AVAILABLE
        end
      end

      alias fetch operating_system

      AVAILABLE.each do |os|
        define_method("#{os}?") do
          operating_system == os
        end
      end
    end
  end
end
