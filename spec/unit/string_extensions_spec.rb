require_relative '../../lib/dirwatch/string_extensions'

RSpec.describe 'StringExtension' do
  context '#bold' do
    it { expect(''.bold).to eq "\033[1m\033[0m" }
    it { expect('asdf'.bold).to eq "\033[1masdf\033[0m" }
  end
  context '#green' do
    it { expect(''.green).to eq "\033[32m\033[0m" }
    it { expect('asdf'.green).to eq "\033[32masdf\033[0m" }
  end
  context '#red' do
    it { expect(''.red).to eq "\033[31m\033[0m" }
    it { expect('asdf'.red).to eq "\033[31masdf\033[0m" }
  end
  context '#yellow' do
    it { expect(''.yellow).to eq "\033[33m\033[0m" }
    it { expect('asdf'.yellow).to eq "\033[33masdf\033[0m" }
  end
end
