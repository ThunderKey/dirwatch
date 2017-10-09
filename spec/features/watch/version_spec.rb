RSpec.describe 'dirwatch --version' do
  context 'with --version' do
    it 'prints the version in the correct format' do
      expect { run '--version' }.to exit_with(0)
        .and output(/\Adirwatch \d+\.\d+\.\d+\n\z/).to_stdout
        .and not_output.to_stderr
    end

    it 'prints the exact version' do
      expect { run '--version' }.to exit_with(0)
        .and output("dirwatch #{Dirwatch::VERSION}\n").to_stdout
        .and not_output.to_stderr
    end
  end
end
