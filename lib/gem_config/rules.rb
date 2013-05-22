module GemConfig
  class Rules < Hash
    def has(key, attrs = {})
      self[key.to_sym] = attrs
    end
  end
end
