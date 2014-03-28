require 'spec_helper'

AfterConfigurationChangeReceived = Class.new(StandardError)

describe GemConfig::Configuration do
  let(:parent) {
    Module.new do
      include GemConfig::Base
    end
  }
  subject do
    GemConfig::Configuration.new(parent).tap do |configuration|
      configuration.rules.has :all_allowed
      configuration.rules.has :foo_bar_allowed, values: %w(foo bar)
      configuration.rules.has :string_allowed, classes: String
      configuration.rules.has :foo, default: 'bar'
      configuration.rules.has :bar
      configuration.rules.has :count
      configuration.rules.has :api_key, default: 'foobarbaz'

      configuration.foo   = 'pelle'
      configuration.count = 123

      configuration
    end
  end

  def set_after_configuration_change_received
    parent.class_eval do
      after_configuration_change do
        raise AfterConfigurationChangeReceived
      end
    end
  end

  describe '#rules' do
    it 'returns a Rules object' do
      subject.rules.is_a?(GemConfig::Rules)
    end
  end

  describe '#current' do
    it 'returns the current configuration' do
      expect(subject.current).to eq(
        all_allowed:     nil,
        foo_bar_allowed: nil,
        string_allowed:  nil,
        foo:             'pelle',
        bar:             nil,
        count:           123,
        api_key:         'foobarbaz'
      )
    end
  end

  describe '#reset' do
    it 'resets the configuration' do
      expect { subject.reset }.to change { [subject.foo, subject.count] }.from(['pelle', 123]).to(['bar', nil])
    end
  end

  describe '#unset' do
    context 'with an existing key' do
      context 'when that key has not been set' do
        it 'doesnt change anything' do
          expect { subject.unset(:bar) }.to_not change { subject.bar }
        end
      end

      context 'when that key has been set' do
        it 'unsets the key' do
          expect { subject.unset(:count) }.to change { subject.count }.from(123).to(nil)
        end
      end
    end

    context 'with a non-existing key' do
      it 'raises an exception' do
        expect { subject.unset(:pelle) }.to raise_error(GemConfig::InvalidKeyError)
      end
    end

    context 'when a after_configuration_change block is present' do
      before do
        set_after_configuration_change_received
      end

      it 'calls that block after setting a new value' do
        expect { subject.unset :count }.to raise_error(AfterConfigurationChangeReceived)
      end
    end
  end

  describe 'setting a configuration option' do
    context 'when all values and classes are allowed' do
      it 'sets the configuration option' do
        expect { subject.all_allowed = 'foo' }.to change { subject.all_allowed }.from(nil).to('foo')
        expect { subject.all_allowed = 'bar' }.to change { subject.all_allowed }.from('foo').to('bar')
      end
    end

    context 'when only certain values are allowed' do
      it 'sets the configuration option to those values' do
        expect { subject.foo_bar_allowed = 'foo' }.to change { subject.foo_bar_allowed }.from(nil).to('foo')
        expect { subject.foo_bar_allowed = 'bar' }.to change { subject.foo_bar_allowed }.from('foo').to('bar')
      end

      it 'raises an error when for other values' do
        expect { subject.foo_bar_allowed = 'pelle' }.to raise_error(GemConfig::InvalidKeyError)
      end

      it "doesn't set the configuration option for other values" do
        expect do
          begin
            subject.foo_bar_allowed = 'pelle'
          rescue GemConfig::InvalidKeyError
          end
        end.to_not change { subject.foo_bar_allowed }
      end
    end

    context 'when only certain classes are allowed' do
      it 'sets the configuration option to those classes' do
        expect { subject.string_allowed = 'foo' }.to change { subject.string_allowed }.from(nil).to('foo')
        expect { subject.string_allowed = 'bar' }.to change { subject.string_allowed }.from('foo').to('bar')
      end

      it 'raises an error when for other values' do
        expect { subject.string_allowed = 1 }.to raise_error(GemConfig::InvalidKeyError)
      end

      it "doesn't set the configuration option for other values" do
        expect do
          begin
            subject.string_allowed = 1
          rescue GemConfig::InvalidKeyError
          end
        end.to_not change { subject.string_allowed }
      end
    end

    context 'when a after_configuration_change block is present' do
      before do
        set_after_configuration_change_received
      end

      it 'calls that block after setting a new value' do
        expect { subject.all_allowed = 'foo' }.to raise_error(AfterConfigurationChangeReceived)
      end
    end
  end

  describe 'getting a configuration option' do
    it 'returns the value if it is set' do
      subject.foo = 'bar'
      expect(subject.foo).to eq('bar')
    end

    it 'also accepts nil as a value' do
      subject.foo = nil
      expect(subject.foo).to be_nil
    end

    it 'returns the default if no value but a default is set' do
      expect(subject.api_key).to eq('foobarbaz')
    end
  end
end
