require 'spec_helper'

describe GemConfig::Configuration do
  subject do
    GemConfig::Configuration.new.tap do |configuration|
      configuration.rules.has :foo
      configuration.rules.has :count
      configuration.foo   = 'bar'
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
      subject.current.should eq(foo: 'bar', count: 123)
    end
  end

  describe '#reset' do
    it 'resets the configuration' do
      subject.tap(&:reset).current.should eq(foo: nil, count: nil)
    end
  end
end
