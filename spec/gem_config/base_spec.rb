require 'spec_helper'

describe GemConfig::Base do
  it 'provides a class method `with_configuration` when included' do
    m = Module.new do
      include GemConfig::Base
    end

    expect(m).to respond_to(:with_configuration)
  end

  it 'provides a class method `after_configuration_change` when included' do
    m = Module.new do
      include GemConfig::Base
    end

    expect(m).to respond_to(:after_configuration_change)
  end
end
