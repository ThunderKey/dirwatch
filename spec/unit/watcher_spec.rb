RSpec.describe Dirwatch::Watcher, with_settings: true do
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
      create_settings <<-YAML
mytest: {}
YAML
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output("file_match must be set\n").to_stderr
    end

    it 'aborts without a file_match' do
      create_settings <<-YAML
mytest:
  file_match: "*.txt"
YAML
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output("interval must be set\n").to_stderr
    end

    it 'aborts without a file_match' do
      create_settings <<-YAML
mytest:
  file_match: "*.txt"
  interval: 10
YAML
      expect { run }.to exit_with(1)
        .and not_output.to_stdout
        .and output("Script needs to be a string or a list of strings: nil\n").to_stderr
    end
  end

  it 'calls the watcher correctly' do
    create_settings <<-YAML
mytest:
  file_match: "*.txt"
  interval: 10
  script: echo test
YAML
    @watcher = nil
    expect_any_instance_of(Dirwatch::Watcher).to receive(:start) do |watcher|
      @watcher = watcher
    end
    expect_any_instance_of(Dirwatch::Watcher).to receive(:stop).and_return nil
    expect_any_instance_of(Dirwatch::Watcher).to receive(:wait_for_stop).and_return nil
    expect { run }.to exit_with(0)
      .and output("Watching files...\nshutting down...\n").to_stdout
      .and not_output.to_stderr

    expect(@watcher).to_not eq nil
    expect(@watcher.settings.watch_settings.map(&:to_h)).to eq [
      {
        directory:  './',
        file_match: '*.txt',
        interval:   10,
        scripts:    ['echo test'],
      },
    ]
    expect(@watcher.settings.watch_settings.map(&:to_s)).to eq [
      'directory="./" file_match="*.txt" interval=10 scripts=["echo test"]',
    ]
    expect(@watcher.settings.watch_settings.map(&:inspect)).to eq [
      '#<Dirwatch::Settings::WatchSetting mytest: directory="./" file_match="*.txt" interval=10 scripts=["echo test"]>',
    ]
  end
end
