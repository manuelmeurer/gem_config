require 'spec_helper'

describe 'a module with configuration rules' do
  subject do
    Module.new do
      include GemConfig::Base

      with_configuration do
        has :foo, classes: String
        has :bar, classes: Numeric, default: 1
        has :baz, values: %w(lorem ipsum dolor), default: 'lorem'
      end
    end
  end

  it 'can be configured' do
    expect do
      subject.configure do |config|
        config.foo = 'bar'
        config.baz = 'ipsum'
      end
    end.to_not raise_error

    expect(subject.configuration.foo).to eq('bar')
    expect(subject.configuration.baz).to eq('ipsum')
  end
end
