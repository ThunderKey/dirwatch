RSpec.shared_examples 'os specific list' do |small_output, large_output|
  it 'lists the templates' do
    expect { run_init '--list' }.to output(small_output).to_stdout.and not_output.to_stderr
  end

  it 'lists the templates verbosely' do
    expect { run_init '--list', '--verbose' }.to output(large_output).to_stdout
      .and not_output.to_stderr
    expect { run_init '--list', '-v' }.to output(large_output).to_stdout
      .and not_output.to_stderr
  end
end

RSpec.describe 'dirwatch init --list' do
  context 'on a linux' do
    before { stub_host_os :linux }
    small = <<-EOT
All available templates:
  \033[1mlatex\033[0m (\033[1mlinux\033[0m, mac, windows)
EOT
    large = <<-EOT
Operating system: linux
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/windows/latex.yml (latex)
  \033[1mlatex\033[0m (\033[1mlinux\033[0m, mac, windows)
EOT
    it_behaves_like 'os specific list', small, large
  end

  context 'on a mac' do
    before { stub_host_os :mac }
    small = <<-EOT
All available templates:
  \033[1mlatex\033[0m (linux, \033[1mmac\033[0m, windows)
EOT
    large = <<-EOT
Operating system: mac
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/windows/latex.yml (latex)
  \033[1mlatex\033[0m (linux, \033[1mmac\033[0m, windows)
EOT
    it_behaves_like 'os specific list', small, large
  end

  context 'on a windows' do
    before { stub_host_os :windows }
    small = <<-EOT
All available templates:
  \033[1mlatex\033[0m (linux, mac, \033[1mwindows\033[0m)
EOT
    large = <<-EOT
Operating system: windows
All available templates:
  Searching files: #{RSpec.root}/lib/dirwatch/templates/linux/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/linux/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/mac/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/mac/latex.yml (latex)
  Searching files: #{RSpec.root}/lib/dirwatch/templates/windows/*.yml
    Found: #{RSpec.root}/lib/dirwatch/templates/windows/latex.yml (latex)
  \033[1mlatex\033[0m (linux, mac, \033[1mwindows\033[0m)
EOT
    it_behaves_like 'os specific list', small, large
  end
end
