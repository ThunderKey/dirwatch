RSpec.describe 'dirwatch' do
  def run *args
    Dirwatch.run_from_args args
  end

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
      expect { run '--help' }.to output(help_message).to_stdout
        .and not_output.to_stderr
    end

    it 'with -h' do
      expect { run '-h' }.to output(help_message).to_stdout
        .and not_output.to_stderr
    end

    it 'too many arguments' do
      expect { run 'arg1', 'arg2' }.to output(help_message).to_stdout
        .and output(<<-EOT).to_stderr
Unknown arguments: "arg1", "arg2"
Allowed optional arguments: 1
EOT
    end
  end

  context 'prints a version' do
    it 'with --version' do
      expect { run '--version' }.to output(/\Adirwatch \d+\.\d+\.\d+\n\z/).to_stdout
        .and not_output.to_stderr
      expect { run '--version' }.to output("dirwatch #{Dirwatch::VERSION}\n").to_stdout
        .and not_output.to_stderr
    end
  end
end
