RSpec.describe 'dirwatch --help' do
  let(:help_message) { <<-OUTPUT }
Usage: dirwatch [options] [directory|file]
    -v, --[no-]verbose               Print additional information
    -d, --[no-]daemonize             Run the programm as a daemon
        --once                       Run the programm only once
        --version                    Show the version
    -h, --help                       Show this help message

Other Methods:
    dirwatch init [options] [template]

Version: #{Dirwatch::VERSION}
OUTPUT

  it 'with --help' do
    expect { run '--help' }.to exit_with(0)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'with -h' do
    expect { run '-h' }.to exit_with(0)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'too many arguments' do
    expect { run 'arg1', 'arg2' }.to exit_with(1)
      .and output(help_message).to_stdout
      .and output(<<-OUTPUT).to_stderr
Unknown arguments: "arg1", "arg2"
Allowed optional arguments: 1
OUTPUT
  end

  it 'is executed correctly from the command line' do
    cmd = "#{RSpec.root.join('bin', (windows? ? 'dirwatch.rb' : 'dirwatch'))} arg1 arg2 arg3"
    stdout, stderr, status = Open3.capture3 cmd
    expect(stdout).to eq help_message
    expect(stderr).to eq <<-OUTPUT
Unknown arguments: "arg1", "arg2", "arg3"
Allowed optional arguments: 1
OUTPUT
    expect(status.exitstatus).to eq 1
  end
end
