RSpec.describe 'dirwatch --help' do
  let(:help_message) { <<-EOT }
Usage: dirwatch [options] [directory]
    -v, --[no-]verbose               Print additional information
    -d, --[no-]daemonize             Run the programm as a daemon
        --version                    Show the version
    -h, --help                       Show this help message

Other Methods:
    dirwatch init [options] [template]
EOT

  it 'with --help' do
    expect { run '--help' }.to throw_symbol(:exit)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'with -h' do
    expect { run '-h' }.to throw_symbol(:exit)
      .and output(help_message).to_stdout
      .and not_output.to_stderr
  end

  it 'too many arguments' do
    expect { run 'arg1', 'arg2' }.to throw_symbol(:exit)
      .and output(help_message).to_stdout
      .and output(<<-EOT).to_stderr
Unknown arguments: "arg1", "arg2"
Allowed optional arguments: 1
EOT
  end
end
