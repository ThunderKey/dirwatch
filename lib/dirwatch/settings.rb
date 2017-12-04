require_relative 'settings/watch_setting'
require_relative 'symbolize_extensions'

module Dirwatch
  class Settings
    def self.from_options options
      file = if File.file? options.directory
        options.directory
      else
        File.join(options.directory, '.dirwatch.yml')
      end
      Settings.from_file(file, options)
    end

    def self.from_file filename, options
      raise FileNotFoundError, filename unless File.exist? filename
      settings = new
      config = YAML.load_file(filename).symbolize_keys
      raise FileEmptyError, filename unless config
      settings.import_config config, options.directory
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

    def add_from_config key, watch_setting, defaults, directory
      add WatchSetting.new(
        key,
        directory:  directory,
        file_match: watch_setting[:file_match] || defaults[:file_match],
        interval:   watch_setting[:interval]   || defaults[:interval],
        scripts:    watch_setting[:script]     || defaults[:script],
      )
    end

    def by_interval &block
      @watch_settings.group_by(&:interval).each(&block)
    end

    def import_config config, directory
      watch_data = {}
      defaults = {}
      config.each do |key, watch_setting|
        if key == :defaults
          defaults.merge! watch_setting
        else
          watch_data[key] = watch_setting
        end
      end
      watch_data.each do |key, watch_setting|
        add_from_config key, watch_setting, defaults, directory
      end
    end
  end
end
