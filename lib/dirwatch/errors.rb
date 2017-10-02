module Dirwatch
  class FileNotFoundError < IOError
    attr_reader :filename
    def initialize filename, msg = nil
      super msg || "Could not find the configuration file #{filename}"
      @filename = filename
    end
  end

  class TemplateNotFoundError < StandardError
    attr_reader :template
    def initialize template, msg = nil
      super msg || "Could not find the template #{template}"
      @template = template
    end
  end

  class OsNotSupportedError < StandardError
    attr_reader :os, :available
    def initialize os, available, msg = nil
      super msg || "The operating system #{os} is not supported. Only #{available.join ', '}"
      @os = os
      @available = available
    end
  end
end
