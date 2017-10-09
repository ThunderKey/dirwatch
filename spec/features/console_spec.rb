RSpec.describe 'Console' do
  [
    [],
    %w(testarg1),
    %w(testarg1 testarg2),
    %w(testarg1 testarg2 testarg3),
  ].each do |args|
    it "passes the arguments #{args.inspect} to the Dirwatch runner" do
      expect(Dirwatch).to receive(:run_from_args).with args
      stub_const 'ARGV', args
      load RSpec.root.join('bin', 'dirwatch')
    end
  end

  [
    0,
    1,
    2,
    100,
  ].each do |exit_code|
    it "exits with the code #{exit_code}" do
      expect(Dirwatch).to receive(:run_from_args).with([]).and_throw :exit, exit_code
      stub_const 'ARGV', []
      expect { load RSpec.root.join('bin', 'dirwatch') }.to exit_with exit_code
    end
  end
end
