RSpec.describe 'dirwatch watch options' do
  let :watcher_stub do
    stub = double()
    expect(stub).to receive(:start)
    expect(stub).to receive(:wait_for_stop)
    expect(stub).to receive(:stop)
    stub
  end

  {
    [] => {
      directory: './',
      daemonize: false,
      verbose:   false,
    },
    ['--verbose'] => {
      directory: './',
      daemonize: false,
      verbose:   true,
    },
    ['-v'] => {
      directory: './',
      daemonize: false,
      verbose:   true,
    },
    ['--daemonize'] => {
      directory: './',
      daemonize: true,
      verbose:   false,
    },
    ['-d'] => {
      directory: './',
      daemonize: true,
      verbose:   false,
    },
    ['test_dir'] => {
      directory: 'test_dir',
      daemonize: false,
      verbose:   false,
    },
    ['--verbose', '--daemonize', 'test_dir'] => {
      directory: 'test_dir',
      daemonize: true,
      verbose:   true,
    },
    ['test_dir', '--verbose', '--daemonize'] => {
      directory: 'test_dir',
      daemonize: true,
      verbose:   true,
    },
  }.each do |args, options|
    it "creates the correct options for #{args.inspect}" do
      expect(Dirwatch::Watcher).to receive(:new)
        .with(an_option_with(:watch, options))
        .and_return watcher_stub
      expect { run(*args) }.to output("shutting down...\n").to_stdout.and not_output.to_stderr
    end
  end
end
