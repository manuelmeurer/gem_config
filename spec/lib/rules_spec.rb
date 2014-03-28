require 'spec_helper'

describe GemConfig::Rules do
  subject { GemConfig::Rules.new }

  describe '#has' do
    it 'sets a rule' do
      subject.has :foo
      expect(subject).to have_key(:foo)
    end

    it 'sets the parameters of a rule' do
      params = { classes: String, values: %w(foo bar), default: 'foo' }
      subject.has :foo, params
      expect(subject[:foo]).to eq(params)
    end

    it 'only allows certain parameters' do
      expect do
        subject.has :foo, classes: String
      end.to_not raise_error

      expect do
        subject.has :foo, values: 'bar'
      end.to_not raise_error

      expect do
        subject.has :foo, default: 'bar'
      end.to_not raise_error

      expect do
        subject.has :foo, foo: 'bar'
      end.to raise_error(ArgumentError)
    end

    describe 'parameters' do
      it 'raises an exception when a not allowed parameter is passed' do
        expect do
          subject.has :foo, bar: 'baz'
        end.to raise_error(ArgumentError)
      end

      describe 'parameter :classes' do
        it 'only allows a class or an array of classes as the value' do
          expect do
            subject.has :foo, classes: String
          end.to_not raise_error

          expect do
            subject.has :foo, classes: [String, Numeric]
          end.to_not raise_error

          expect do
            subject.has :foo, classes: 'foo'
          end.to raise_error(ArgumentError)
        end
      end

      describe 'parameter :values' do
        context 'when :classes are defined' do
          it 'only allows values of one of the specified classes' do
            expect do
              subject.has :foo, classes: String, values: 'foo'
            end.to_not raise_error

            expect do
              subject.has :foo, classes: Numeric, values: 1
            end.to_not raise_error

            expect do
              subject.has :foo, classes: [String, Numeric], values: ['foo', 1]
            end.to_not raise_error

            expect do
              subject.has :foo, classes: String, values: ['foo', 1]
            end.to raise_error(ArgumentError)
          end
        end
      end

      describe 'parameter :default' do
        context 'when :classes are defined' do
          it 'only allows a value of one of the specified classes' do
            expect do
              subject.has :foo, classes: String, default: 'foo'
            end.to_not raise_error

            expect do
              subject.has :foo, classes: Numeric, default: 1
            end.to_not raise_error

            expect do
              subject.has :foo, classes: [String, Numeric], default: 'foo'
            end.to_not raise_error

            expect do
              subject.has :foo, classes: Numeric, default: 'foo'
            end.to raise_error(ArgumentError)
          end
        end

        context 'when :values are defined' do
          it 'only allows one of the specified values' do
            expect do
              subject.has :foo, values: 'foo', default: 'foo'
            end.to_not raise_error

            expect do
              subject.has :foo, values: ['foo', 1], default: 1
            end.to_not raise_error

            expect do
              subject.has :foo, values: ['foo', 1], default: 'bar'
            end.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe '#check' do
    it "raises an error if the value is not set as a rule" do
      expect do
        subject.check :foo, 1
      end.to raise_error(GemConfig::InvalidKeyError)
    end

    it "raises an error if :classes are defined the the value's class is not included in them" do
      subject.has :foo, classes: String
      expect do
        subject.check :foo, 1
      end.to raise_error(GemConfig::InvalidKeyError)
    end

    it 'raises an error if :values are defined the the value is not included in them' do
      subject.has :foo, values: ['foo', 'bar']
      expect do
        subject.check :foo, 'baz'
      end.to raise_error(GemConfig::InvalidKeyError)
    end

    it "does not raise an error if :classes are defined the the value's class is included in them" do
      subject.has :foo, classes: [String, Numeric]
      expect do
        subject.check :foo, 1
      end.to_not raise_error
    end

    it 'does not raise an error if :values are defined the the value is included in them' do
      subject.has :foo, values: ['foo', 'bar']
      expect do
        subject.check :foo, 'foo'
      end.to_not raise_error
    end
  end
end
