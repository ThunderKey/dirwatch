RSpec.shared_examples 'os specific default template creation' do |os, content|
  before { stub_host_os os }
  it "creates a default template for #{os}" do
    expect(File.exist?(config_file)).to be false
    expect { scoped_run_init }.to output(<<-EOT).to_stdout.and not_output.to_stderr
creating latex
  \e[32mcreated        \e[0m .dirwatch.yml
EOT
    expect(File.exist?(config_file)).to be true
    expect(File.read(config_file)).to eq content
  end

  ['-v', '--verbose'].each do |v|
    it "creates a default template in #{v} mode for #{os}" do
      expect(File.exist?(config_file)).to be false
      expect { scoped_run_init v }.to output(<<-EOT).to_stdout.and not_output.to_stderr
creating latex
  \e[32mcreated        \e[0m .dirwatch.yml
EOT
      expect(File.exist?(config_file)).to be true
      expect(File.read(config_file)).to eq content
    end
  end
end

RSpec.describe 'dirwatch init' do
  let(:tmp_dir) { File.join RSpec.spec_root, 'tmp' }
  let(:config_file) { File.join tmp_dir, '.dirwatch.yml' }

  def scoped_run_init *args
    Dir.chdir(tmp_dir) do
      run_init(*args)
    end
  end

  before(:each) do
    FileUtils.rm_rf tmp_dir if File.exist? tmp_dir
    FileUtils.mkdir tmp_dir
  end

  after(:each) do
    FileUtils.rm_rf tmp_dir
  end

  it_behaves_like 'os specific default template creation', :linux, <<-EOT
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex main.tex
    - evince main.pdf &
EOT

  it_behaves_like 'os specific default template creation', :mac, <<-EOT
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex main.tex
    - open main.pdf &
EOT

  it_behaves_like 'os specific default template creation', :windows, <<-EOT
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex.exe main.tex
    - start "" "main.pdf"
EOT
end
