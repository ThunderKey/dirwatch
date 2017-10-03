require_relative '../../lib/dirwatch/symbolize_extensions'

RSpec.describe 'SymbolizeExtension' do
  it { expect('mytest'.symbolize_keys).to eq 'mytest' }
  it { expect(['mytest'].symbolize_keys).to eq ['mytest'] }
  it { expect({'t1' => 'mytest'}.symbolize_keys).to eq(t1: 'mytest') }
  it { expect({'t1' => {'t2' => 'mytest'}, t3: ['mytest2']}.symbolize_keys).to eq(t1: {t2: 'mytest'}, t3: ['mytest2']) }
  it { expect({t1: [{'t2' => 'mytest'}, 'mytest2']}.symbolize_keys).to eq(t1: [{t2: 'mytest'}, 'mytest2']) }
end
