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
end
