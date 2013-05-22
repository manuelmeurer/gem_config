require 'spec_helper'

describe GemConfig::Base do
  it 'provides a class method `with_configuration` when included' do
    m = Module.new do
      include GemConfig::Base
    end

    m.should respond_to(:with_configuration)
  end
end
