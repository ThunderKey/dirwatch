RSpec.configure do |config|
  def create_settings settings, file = '.dirwatch.yml'
    File.write file, settings
  end

  def create_default_settings file = '.dirwatch.yml'
    create_settings <<-YAML, file
mytest1:
  file_match: "*.txt"
  interval: 5
  script: echo test
YAML
  end

  config.around(with_settings: true) do |example|
    dir = defined?(test_dir) ? test_dir : RSpec.spec_root.join('tmp', 'example').to_s

    FileUtils.rm_r dir if File.exist? dir
    FileUtils.mkdir_p dir
    cd(dir) do
      example.run
    end
    FileUtils.rm_r dir
  end
end
