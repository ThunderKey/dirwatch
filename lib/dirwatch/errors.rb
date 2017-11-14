module Dirwatch
  module UserFriendlyError
    def user_friendly_message
      message
    end
  end

  class FileNotFoundError < IOError
    include UserFriendlyError

    attr_reader :filename
    def initialize filename, msg = nil
      super msg || "Could not find the file #{filename.inspect}"
      @filename = filename
    end
  end

  class FileEmptyError < IOError
    include UserFriendlyError

    attr_reader :filename
    def initialize filename, msg = nil
      super msg || "The file #{filename.inspect} is empty"
      @filename = filename
    end
  end

  class InvalidValueError < StandardError
    include UserFriendlyError
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
