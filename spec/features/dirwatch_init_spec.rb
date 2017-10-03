RSpec.describe 'dirwatch init' do
  context 'prints a help message' do
    let(:help_message) { <<-EOT }
Usage: dirwatch init [options] [template]
    -v, --[no-]verbose               Print additional information
    -l, --[no-]list                  List all available templates
    -f, --[no-]force                 Overwrite the dirwatch.yml if it already exists
        --os OS                      Set the operating system to use. Otherwise it tries to detect it.
    -h, --help                       Show this help message

Other Methods:
    dirwatch [options] [directory]
EOT

    it 'with --help' do
      expect { expect { Dirwatch.run_from_args(['init', '--help']) }.to output(help_message).to_stdout }.to_not output.to_stderr
    end

    it 'too many arguments' do
      expect { expect { Dirwatch.run_from_args(['init', 'arg1', 'arg2']) }.to output(help_message).to_stdout }.to output(%Q{Unknown arguments: "arg1", "arg2"\n}).to_stderr
    end
  end

  context 'available templates' do
    it 'lists the templates' do
      expect { expect { Dirwatch.run_from_args(['init', '--list']) }.to output(<<-EOT).to_stdout }.to_not output.to_stderr
All available templates:
  \033[1mlatex\033[0m (mac, \033[1mlinux\033[0m)
EOT
    end

    it 'lists the templates verbosely' do
      list_message = <<-EOT
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  \033[1mlatex\033[0m (mac, \033[1mlinux\033[0m)
EOT
      expect { expect { Dirwatch.run_from_args(['init', '--list', '--verbose']) }.to output(list_message).to_stdout }.to_not output.to_stderr
      expect { expect { Dirwatch.run_from_args(['init', '--list', '-v']) }.to output(list_message).to_stdout }.to_not output.to_stderr
    end
  end
end
