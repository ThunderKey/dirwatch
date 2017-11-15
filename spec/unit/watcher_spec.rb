RSpec.describe Dirwatch::Watcher do
  def create_settings settings, file = settings_file
    File.write file, settings
  end

  let(:test_dir) { RSpec.spec_root.join('tmp', 'example').to_s }
  let(:settings_file) { '.dirwatch.yml' }

  around(:each) do |example|
    FileUtils.rm_r test_dir if File.exist? test_dir
    FileUtils.mkdir_p test_dir
    cd(test_dir) do
      example.run
    end
    FileUtils.rm_r test_dir
  end

  it 'aborts with missing file' do
    expect { run }.to exit_with(1)
      .and not_output.to_stdout
      .and output(%Q{Could not find the file "./.dirwatch.yml"\n}).to_stderr
  end

  it 'aborts with an empty file' do
    create_settings ''
    expect { run }.to exit_with(1)
      .and not_output.to_stdout
      .and output(%Q{The file "./.dirwatch.yml" is empty\n}).to_stderr
  end

  context 'with an invalid file' do
    it 'aborts without a file_match' do
      create_settings <<-EOT
mytest: {}
EOT
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output(%Q{file_match must be set\n}).to_stderr
    end

    it 'aborts without a file_match' do
      create_settings <<-EOT
mytest:
  file_match: "*.txt"
EOT
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output(%Q{interval must be set\n}).to_stderr
    end

    it 'aborts without a file_match' do
      create_settings <<-EOT
mytest:
  file_match: "*.txt"
  interval: 10
EOT
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output(%Q{Script needs to be a string or a list of strings: nil\n}).to_stderr
    end
  end

  it 'calls the watcher correctly' do
    create_settings <<-EOT
mytest:
  file_match: "*.txt"
  interval: 10
  script: echo test
EOT
    expect_any_instance_of(Dirwatch::Watcher).to receive(:start) do |watcher|
      expect(watcher.settings.watch_settings.map(&:to_h)).to eq [
        {
          directory:  './',
          file_match: '*.txt',
          interval:   10,
          scripts:    ['echo test'],
        },
      ]
      expect(watcher.settings.watch_settings.map(&:to_s)).to eq [
        '#<Dirwatch::Settings::WatchSetting mytest: directory="./" file_match="*.txt" interval=10 scripts=["echo test"]>',
      ]
    end
    expect_any_instance_of(Dirwatch::Watcher).to receive(:stop).and_return nil
    expect_any_instance_of(Dirwatch::Watcher).to receive(:wait_for_stop).and_return nil
    expect { run }.to output("shutting down...\n").to_stdout.and not_output.to_stderr
  end
end
