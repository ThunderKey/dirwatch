RSpec.describe Dirwatch::OsFetcher do
  def stub_host_os os
    allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return os
  end

  subject { described_class }
  # linux
  %w(linux).each do |os|
    it "matches #{os}" do
      stub_host_os os
      expect(subject.operating_system).to eq :linux
      expect(subject.fetch).to eq :linux
      expect(subject.linux?).to be true
      expect(subject.mac?).to be false
      expect(subject.windows?).to be false
    end
  end

  # mac
  %w(darwin mac\ os).each do |os|
    it "matches #{os}" do
      stub_host_os os
      expect(subject.operating_system).to eq :mac
      expect(subject.fetch).to eq :mac
      expect(subject.linux?).to be false
      expect(subject.mac?).to be true
      expect(subject.windows?).to be false
    end
  end

  # windows
  %w(mswin win32 dos mingw cygwin).each do |os|
    it "matches #{os}" do
      stub_host_os os
      expect(subject.operating_system).to eq :windows
      expect(subject.fetch).to eq :windows
      expect(subject.linux?).to be false
      expect(subject.mac?).to be false
      expect(subject.windows?).to be true
    end
  end

  # unsupported
  %w(solaris bsd unknown).each do |os|
    it "matches #{os}" do
      stub_host_os os
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
end
