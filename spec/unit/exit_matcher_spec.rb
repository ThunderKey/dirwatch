RSpec.describe 'exit matchers' do
  error = RSpec::Expectations::ExpectationNotMetError

  [:exit_with, :call_exit_with].each do |m|
    context(m) do
      it 'succeeds if the exit status matches' do
        expect { exit 5 }.to send(m, 5)
      end

      it 'prints the correct failure message if the exit status mismatches' do
        expect do
          expect { exit 5 }.to send(m, 4)
        end.to raise_exception error, <<-EOT
expected: exit status == 4
     got:                5
EOT
      end

      it 'prints the correct failure message if exit was not called' do
        expect do
          expect { }.to send(m, 4)
        end.to raise_exception error, 'expected the exit status to match 4 but exit was not called'
      end
    end

    context("not #{m}") do
      it 'succeeds if the exit status mismatches' do
        expect { exit 5 }.to_not send(m, 10)
      end

      it 'prints the correct failure message if the exit status matches' do
        expect do
          expect { exit 5 }.to_not send(m, 5)
        end.to raise_exception error, <<-EOT
expected: exit status != 5
     got:                5
EOT
      end

      it 'prints the correct failure message if exit was not called' do
        expect do
          expect { }.to_not send(m, 4)
        end.to raise_exception error, 'expected the exit status to not match 4 but exit was not called'
      end
    end
  end

  context 'call_exit' do
    it 'succeeds if exit is called' do
      expect { exit }.to call_exit
    end

    it 'succeeds if exit is called with a parameter' do
      expect { exit 5 }.to call_exit
    end

    it 'prints the correct failure message if exit is called' do
      expect do
        expect { }.to call_exit
      end.to raise_exception error, 'expected the Kernel.exit method to be called'
    end
  end

  context 'not call_exit' do
    it 'succeeds if no exit is called' do
      expect { }.to_not call_exit
    end

    it 'prints the correct failure message if exit is called' do
      expect do
        expect { exit }.to_not call_exit
      end.to raise_exception error, 'expected the Kernel.exit method to not be called'
    end

    it 'prints the correct failure message if exit is called with a parameter' do
      expect do
        expect { exit 5 }.to_not call_exit
      end.to raise_exception error, 'expected the Kernel.exit method to not be called'
    end
  end
end
