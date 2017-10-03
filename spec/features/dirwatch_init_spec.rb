RSpec.shared_examples 'os specific list' do |small_output, large_output|
  it 'lists the templates' do
    expect { run '--list' }.to output(small_output).to_stdout.and not_output.to_stderr
  end

  it 'lists the templates verbosely' do
    expect { run '--list', '--verbose' }.to output(large_output).to_stdout
      .and not_output.to_stderr
    expect { run '--list', '-v' }.to output(large_output).to_stdout
      .and not_output.to_stderr
  end
end

RSpec.describe 'dirwatch init' do
  def run *args
    Dirwatch.run_from_args ['init', *args]
  end

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
      expect { run '--help' }.to output(help_message).to_stdout
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

  context 'on a linux' do
    before { stub_host_os :linux }
    small = <<-EOT
All available templates:
  \033[1mlatex\033[0m (mac, \033[1mlinux\033[0m)
EOT
    large = <<-EOT
Operating system: linux
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  \033[1mlatex\033[0m (mac, \033[1mlinux\033[0m)
EOT
    it_behaves_like 'os specific list', small, large
  end

  context 'on a mac' do
    before { stub_host_os :mac }
    small = <<-EOT
All available templates:
  \033[1mlatex\033[0m (\033[1mmac\033[0m, linux)
EOT
    large = <<-EOT
Operating system: mac
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  \033[1mlatex\033[0m (\033[1mmac\033[0m, linux)
EOT
    it_behaves_like 'os specific list', small, large
  end

  context 'on a windows' do
    before { stub_host_os :windows }
    small = <<-EOT
All available templates:
  latex (mac, linux)
EOT
    large = <<-EOT
Operating system: windows
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  latex (mac, linux)
EOT
    it_behaves_like 'os specific list', small, large
  end
end
