RSpec.describe 'Console' do
  [
    [],
    ['testarg1'],
    ['testarg1', 'testarg2'],
    ['testarg1', 'testarg2', 'testarg3'],
  ].each do |args|
    it "passes the arguments #{args.inspect} to the Dirwatch runner" do
      expect(Dirwatch).to receive(:run_from_args).with args
      stub_const 'ARGV', args
      load RSpec.root.join('bin', 'dirwatch')
    end
  end
end
