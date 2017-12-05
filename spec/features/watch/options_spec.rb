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
      once:      false,
      verbose:   false,
    },
    ['--verbose'] => {
      directory: './',
      daemonize: false,
      once:      false,
      verbose:   true,
    },
    ['-v'] => {
      directory: './',
      daemonize: false,
      once:      false,
      verbose:   true,
    },
    ['--daemonize'] => {
      directory: './',
      daemonize: true,
      once:      false,
      verbose:   false,
    },
    ['-d'] => {
      directory: './',
      daemonize: true,
      once:      false,
      verbose:   false,
    },
    ['--once'] => {
      directory: './',
      daemonize: false,
      once:      true,
      verbose:   false,
    },
    ['test_dir'] => {
      directory: 'test_dir',
      daemonize: false,
      once:      false,
      verbose:   false,
    },
    ['--verbose', '--daemonize', '--once', 'test_dir'] => {
      directory: 'test_dir',
      daemonize: true,
      once:      true,
      verbose:   true,
    },
    ['test_dir', '--verbose', '--daemonize', '--once'] => {
      directory: 'test_dir',
      daemonize: true,
      once:      true,
      verbose:   true,
    },
  }.each do |args, options|
    it "creates the correct options for #{args.inspect}" do
      expect(Dirwatch::Watcher).to receive(:new)
        .with(an_option_with(:watch, options))
        .and_return watcher_stub
      expect { run(*args) }.to exit_with(0)
        .and output("Watching files...\nshutting down...\n").to_stdout
        .and not_output.to_stderr
    end
  end
end
