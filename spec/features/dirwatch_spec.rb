RSpec.describe 'dirwatch' do
  context 'prints a help message' do
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
      expect { expect { Dirwatch.run_from_args(['--help']) }.to output(help_message).to_stdout }.to_not output.to_stderr
    end

    it 'too many arguments' do
      expect { expect { Dirwatch.run_from_args(['arg1', 'arg2']) }.to output(help_message).to_stdout }.to output(%Q{Unknown arguments: "arg1", "arg2"\n}).to_stderr
    end
  end
end
