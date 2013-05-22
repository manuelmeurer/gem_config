require 'spec_helper'

describe GemConfig::Rules do
  subject { GemConfig::Rules.new }

  describe '#has' do
    it 'sets a rule' do
      subject.has :foo
      subject.should have_key(:foo)
    end

    it 'sets the parameters of a rule' do
      params = { classes: String, values: %w(foo bar), default: 'foo' }
      subject.has :foo, params
      subject[:foo].should eq(params)
    end

    it 'only allows certain parameters' do
      expect do
        subject.has :foo, classes: String
      end.to_not raise_error(ArgumentError)

      expect do
        subject.has :foo, values: 'bar'
      end.to_not raise_error(ArgumentError)

      expect do
        subject.has :foo, default: 'bar'
      end.to_not raise_error(ArgumentError)

      expect do
        subject.has :foo, foo: 'bar'
      end.to raise_error(ArgumentError)
    end

    describe 'parameter :classes' do
      it 'only allows a class or an array of classes as the value' do
        expect do
          subject.has :foo, classes: String
        end.to_not raise_error(ArgumentError)

        expect do
          subject.has :foo, classes: [String, Numeric]
        end.to_not raise_error(ArgumentError)

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
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, classes: Numeric, values: 1
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, classes: [String, Numeric], values: ['foo', 1]
          end.to_not raise_error(ArgumentError)

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
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, classes: Numeric, default: 1
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, classes: [String, Numeric], default: 'foo'
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, classes: Numeric, default: 'foo'
          end.to raise_error(ArgumentError)
        end
      end

      context 'when :values are defined' do
        it 'only allows one of the specified values' do
          expect do
            subject.has :foo, values: 'foo', default: 'foo'
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, values: ['foo', 1], default: 1
          end.to_not raise_error(ArgumentError)

          expect do
            subject.has :foo, values: ['foo', 1], default: 'bar'
          end.to raise_error(ArgumentError)
        end
      end
    end
  end
end
