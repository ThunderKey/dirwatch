RSpec.describe 'dirwatch --daemonize', with_settings: true do
  let(:message) { "Watching files...\nshutting down...\n" }

  before(:each) do
    expect_any_instance_of(Dirwatch::Watcher).to receive(:start) {}
    expect_any_instance_of(Dirwatch::Watcher).to receive(:stop) {}
    expect_any_instance_of(Dirwatch::Watcher).to receive(:wait_for_stop) {}

    create_default_settings
  end

  context 'starts in the background' do
    before(:each) do
      expect(Process).to receive(:daemon) do |nochdir, noclose|
        expect(nochdir).to eq true
        expect(noclose).to eq true
      end
    end

    def validate_output &block
      if Gem.win_platform?
        expect(&block).to exit_with(1)
          .and not_output.to_stdout
          .and output('Your operating system does not support daemonize').to_stderr
      else
        expect(&block).to exit_with(0)
          .and output("running in the background... [#{Process.pid}]\n#{message}").to_stdout
          .and not_output.to_stderr
      end
    end

    it 'with --daemonize' do
      validate_output { run '--daemonize' }
    end

    it 'with -d' do
      validate_output { run '-d' }
    end
  end

  context 'starts in the foreground' do
    before(:each) do
      expect(Process).to_not receive(:daemon)
    end

    it 'with --no-daemonize' do
      expect { run '--no-daemonize' }.to exit_with(0)
        .and output(message).to_stdout
        .and not_output.to_stderr
    end

    it 'with no argument' do
      expect { run }.to exit_with(0)
        .and output(message).to_stdout
        .and not_output.to_stderr
    end
  end
end
