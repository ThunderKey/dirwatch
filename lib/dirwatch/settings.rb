require_relative 'settings/watch_setting'

module Dirwatch
  class Settings
    def self.from_options options
      Settings.from_file(File.join(options.directory, 'dirwatch.yml'), options)
    end

    def self.from_file filename, options
      raise FileNotFoundError, filename unless File.exist? filename
      settings = new
      config = symbolize YAML.load_file(filename)
      watch_data = {}
      defaults = {}
      config.each do |key, watch_setting|
        if key == :defaults
          defaults.merge! watch_setting
        else
          watch_data[key] = watch_setting
        end
      end
      watch_data.each do |_key, watch_setting|
        settings << WatchSetting.new(
          directory:  options.directory,
          file_match: watch_setting[:file_match] || defaults[:file_match],
          interval:   watch_setting[:interval]   || defaults[:interval],
          scripts:    watch_setting[:script]     || defaults[:script],
        )
      end
      settings
    end

    attr_reader :watch_settings

    def initialize
      @watch_settings = []
    end

    def << watch_setting
      add watch_setting
    end

    def add watch_setting
      @watch_settings << watch_setting
    end

    def by_interval &block
      @watch_settings.group_by(&:interval).each(&block)
    end

    def self.symbolize(obj)
      return obj.inject({}){|memo,(k,v)| memo[k.to_sym] =  symbolize(v); memo} if obj.is_a? Hash
      return obj.inject([]){|memo,v    | memo           << symbolize(v); memo} if obj.is_a? Array
      return obj
    end
  end
end
