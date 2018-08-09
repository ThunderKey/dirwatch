RSpec.shared_examples 'os specific default template creation' do |os, content|
  before { stub_host_os os }
  it "creates a default template for #{os}" do
    expect(File.exist?(config_file)).to be false
    expect { scoped_run_init }.to exit_with(0)
      .and output(<<-OUTPUT).to_stdout
creating latex
  \e[32mcreated        \e[0m .dirwatch.yml
OUTPUT
      .and not_output.to_stderr
    expect(File.exist?(config_file)).to be true
    expect(File.read(config_file)).to eq content
  end

  ['-v', '--verbose'].each do |v|
    it "creates a default template in #{v} mode for #{os}" do
      expect(File.exist?(config_file)).to be false
      expect { scoped_run_init v }.to exit_with(0)
        .and output(<<-OUTPUT).to_stdout
creating latex
  \e[32mcreated        \e[0m .dirwatch.yml
OUTPUT
        .and not_output.to_stderr
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

  it_behaves_like 'os specific default template creation', :linux, <<-YAML
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex -interaction=nonstopmode -halt-on-error --shell-escape main.tex
    - xdg-open main.pdf
YAML

  it_behaves_like 'os specific default template creation', :mac, <<-YAML
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex -interaction=nonstopmode -halt-on-error --shell-escape main.tex
    - open main.pdf
YAML

  it_behaves_like 'os specific default template creation', :windows, <<-YAML
defaults:
  interval: 1

latex:
  file_match: '*.tex'
  script:
    - pdflatex.exe -interaction=nonstopmode -halt-on-error --shell-escape main.tex
    - start "" "main.pdf"
YAML
end
