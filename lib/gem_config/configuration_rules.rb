module GemConfig
  class ConfigurationRules < Hash
    def has(key, attrs = {})
      self[key.to_sym] = attrs
    end
  end
end
