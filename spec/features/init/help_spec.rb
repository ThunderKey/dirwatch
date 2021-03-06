RSpec.describe 'dirwatch init --help' do
  let(:help_message) { <<-OUTPUT }
Usage: dirwatch init [options] [template]
    -v, --[no-]verbose               Print additional information
    -l, --[no-]list                  List all available templates
    -f, --[no-]force                 Overwrite the .dirwatch.yml if it exists
        --os OS                      Set the operating system to use. Otherwise it tries to detect it.
    -h, --help                       Show this help message

Other Methods:
    dirwatch [options] [directory|file]

Version: #{Dirwatch::VERSION}
OUTPUT

  it 'with --help' do
    expect { run_init '--help' }.to exit_with(0)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'with -h' do
    expect { run_init '-h' }.to exit_with(0)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'too many arguments' do
    expect { run_init 'arg1', 'arg2' }.to exit_with(1)
      .and output(help_message).to_stdout
      .and output(<<-OUTPUT).to_stderr
Unknown arguments: "arg1", "arg2"
Allowed optional arguments: 1
OUTPUT
  end

  it 'is executed correctly from the command line' do
    cmd = "#{RSpec.root.join('bin', (windows? ? 'dirwatch.rb' : 'dirwatch'))} init arg1 arg2 arg3"
    p cmd
    stdout, stderr, status = Open3.capture3 cmd
    expect(stdout).to eq help_message
    expect(stderr).to eq <<-OUTPUT
Unknown arguments: "arg1", "arg2", "arg3"
Allowed optional arguments: 1
OUTPUT
    expect(status.exitstatus).to eq 1
  end
end
