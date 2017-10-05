RSpec.describe 'dirwatch --version' do
  it 'with --version' do
    expect { run '--version' }.to output(/\Adirwatch \d+\.\d+\.\d+\n\z/).to_stdout
      .and not_output.to_stderr
    expect { run '--version' }.to output("dirwatch #{Dirwatch::VERSION}\n").to_stdout
      .and not_output.to_stderr
  end
end
