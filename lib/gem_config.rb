require 'gem_config/version'

module GemConfig
  InvalidKeyError = Class.new(StandardError)
end

require 'gem_config/rules'
require 'gem_config/configuration'
require 'gem_config/base'
