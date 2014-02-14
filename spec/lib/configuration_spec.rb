require 'spec_helper'

describe GemConfig::Configuration do
  subject do
    GemConfig::Configuration.new.tap do |configuration|
      configuration.rules.has :foo, default: 'bar'
      configuration.rules.has :count
      configuration.rules.has :api_key, default: 'foobarbaz'
      configuration.foo   = 'pelle'
      configuration.count = 123
      configuration
    end
  end

  describe '#rules' do
    it 'returns a Rules object' do
      subject.rules.is_a?(GemConfig::Rules)
    end
  end

  describe '#current' do
    it 'returns the current configuration' do
      subject.current.should eq(foo: 'pelle', count: 123, api_key: 'foobarbaz')
    end
  end

  describe '#reset' do
    it 'resets the configuration' do
      subject.tap(&:reset).current.should eq(foo: 'bar', count: nil, api_key: 'foobarbaz')
    end
  end

  describe 'setting a configuration option' do
    it 'checks if the value is allowed' do
      subject.rules.should_receive :check, with: [:foo, 'bar']
      subject.foo = 'bar'
    end

    it 'sets the configuration option if the value is allowed' do
      subject.rules.stub(:check, with: [:foo, 'bar'])
      expect do
        subject.foo = 'bar'
      end.to change { subject.foo }.from('pelle').to('bar')
    end

    it 'does not set the configuration option if the value is not allowed' do
      subject.rules.stub(:check, with: [:foo, 'bar']).and_raise(GemConfig::InvalidKeyError)
      expect do
        begin
          subject.foo = 'bar'
        rescue GemConfig::InvalidKeyError
        end
      end.to_not change { subject.foo }.from('bar')
    end
  end

  describe 'getting a configuration option' do
    it 'returns the value if it is set' do
      subject.foo = 'bar'
      subject.foo.should eq('bar')
    end

    it 'also accepts nil as a value' do
      subject.foo = nil
      subject.foo.should be_nil
    end

    it 'returns the default if no value but a default is set' do
      subject.api_key.should eq('foobarbaz')
    end
  end
end
