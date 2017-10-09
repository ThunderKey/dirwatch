RSpec.configure do
  def stub_host_os os
    if os.is_a? Symbol
      os = case os
      when :linux   then 'linux'
      when :mac     then 'darwin'
      when :windows then 'mswin'
      end
    end

    allow(Dirwatch::OsFetcher).to receive(:host_os).and_return os
  end
end
