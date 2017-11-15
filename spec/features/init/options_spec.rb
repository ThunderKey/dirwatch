RSpec.describe 'dirwatch init options' do
  {
    [] => {
      template:         nil,
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            false,
      verbose:          false,
    },
    ['--verbose'] => {
      template:         nil,
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            false,
      verbose:          true,
    },
    ['-v'] => {
      template:         nil,
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            false,
      verbose:          true,
    },
    ['--force'] => {
      template:         nil,
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            true,
      verbose:          false,
    },
    ['-f'] => {
      template:         nil,
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            true,
      verbose:          false,
    },
    ['--os', 'linux'] => {
      template:         nil,
      operating_system: :linux,
      force:            false,
      verbose:          false,
    },
    ['--os', 'mac'] => {
      template:         nil,
      operating_system: :mac,
      force:            false,
      verbose:          false,
    },
    ['--os', 'windows'] => {
      template:         nil,
      operating_system: :windows,
      force:            false,
      verbose:          false,
    },
    ['test_config.yml'] => {
      template:         'test_config.yml',
      operating_system: Dirwatch::OsFetcher.operating_system,
      force:            false,
      verbose:          false,
    },
    ['--verbose', '--force', '--os', 'windows', 'test_config.yml'] => {
      template:         'test_config.yml',
      operating_system: :windows,
      force:            true,
      verbose:          true,
    },
    ['test_config.yml', '--verbose', '--force', '--os', 'mac'] => {
      template:         'test_config.yml',
      operating_system: :mac,
      force:            true,
      verbose:          true,
    },
  }.each do |args, options|
    it "creates the correct options for #{args.inspect}" do
      expect(Dirwatch::Templates).to receive(:create)
        .with(options)
      expect { run_init(*args) }.to not_output.to_stdout.and not_output.to_stderr
    end
  end
end
