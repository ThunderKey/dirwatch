RSpec.describe 'Console' do
  [
    [],
    %w(testarg1),
    %w(testarg1 testarg2),
    %w(testarg1 testarg2 testarg3),
  ].each do |args|
    it "passes the arguments #{args.inspect} to the Dirwatch runner" do
      expect(Dirwatch.console).to receive(:run).with args
      run(*args)
    end
  end

  [
    0,
    1,
    2,
    100,
  ].each do |exit_code|
    it "exits with the code #{exit_code}" do
      expect_any_instance_of(Dirwatch::Executor).to receive(:run).with([]).and_throw :exit, exit_code
      expect { run }.to exit_with exit_code
    end
  end

  it 'displays the correct error message if a FileNotFoundError occurs' do
    expect_any_instance_of(Dirwatch::Executor).to receive(:run).and_raise Dirwatch::FileNotFoundError, 'my/test/file.txt'
    expect do
      expect { run }.to exit_with 1
    end.to not_output.to_stdout.and output(<<-EOT).to_stderr
Could not find the file "my/test/file.txt"
EOT
  end
end
