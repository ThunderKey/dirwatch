RSpec.shared_examples "a linux matcher" do |os|
  it(os ? "matches the linux #{os.inspect}" : 'matches a linux') do
    stub_host_os os if os
    expect(subject.operating_system).to eq :linux
    expect(subject.fetch).to eq :linux
    expect(subject.linux?).to be true
    expect(subject.mac?).to be false
    expect(subject.windows?).to be false
  end
end

RSpec.shared_examples "a mac matcher" do |os|
  it(os ? "matches the mac #{os.inspect}" : 'matches a mac') do
    stub_host_os os if os
    expect(subject.operating_system).to eq :mac
    expect(subject.fetch).to eq :mac
    expect(subject.linux?).to be false
    expect(subject.mac?).to be true
    expect(subject.windows?).to be false
  end
end

RSpec.shared_examples "a windows matcher" do |os|
  it(os ? "matches the windows #{os.inspect}" : 'matches a windows') do
    stub_host_os os if os
    expect(subject.operating_system).to eq :windows
    expect(subject.fetch).to eq :windows
    expect(subject.linux?).to be false
    expect(subject.mac?).to be false
    expect(subject.windows?).to be true
  end
end

RSpec.shared_examples "an unknown matcher" do |os|
  it(os ? "matches the unknown os #{os.inspect}" : 'matches an unknown os') do
    stub_host_os os if os
    error = "The operating system #{os} is not supported. Only windows, mac, linux"
    [
      :operating_system,
      :fetch,
      :linux?,
      :mac?,
      :windows?,
    ].each do |m|
      expect { subject.send m }.to raise_exception Dirwatch::OsNotSupportedError, error
    end
  end
end

RSpec.describe Dirwatch::OsFetcher do
  def stub_host_os os
    allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return os
  end

  if actual_host_os = ENV['TRAVIS_OS_NAME']
    puts "Testing the actual operating system #{actual_host_os.inspect}"
    case actual_host_os
    when 'linux' then it_behaves_like 'a linux matcher'
    when 'osx' then   it_behaves_like 'a mac matcher'
    else
      raise "Unsupported travis os #{actual_host_os.inspect}"
    end
  end

  subject { described_class }
  # linux
  %w(linux).each do |os|
    it_behaves_like "a linux matcher", os
  end

  # mac
  %w(darwin mac\ os).each do |os|
    it_behaves_like "a mac matcher", os
  end

  # windows
  %w(mswin win32 dos mingw cygwin).each do |os|
    it_behaves_like "a windows matcher", os
  end

  # unsupported
  %w(solaris bsd unknown).each do |os|
    it_behaves_like "an unknown matcher", os
  end
end
