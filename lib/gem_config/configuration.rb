module GemConfig
  class Configuration
    def rules
      @rules ||= Rules.new
    end

    def current
      self.rules.keys.each_with_object({}) do |key, hash|
        hash[key] = get(key)
      end
    end

    def reset
      self.rules.keys.each do |key|
        unset key
      end
    end

    def unset(key)
      raise InvalidKeyError, "#{key} is not a valid key." unless self.rules.keys.include?(key.to_sym)
      remove_instance_variable "@#{key}" if instance_variable_defined?("@#{key}")
    end

    def method_missing(method, *args, &block)
      case
      when self.rules.keys.include?(method.to_sym)
        get method
      when (match = method.to_s.match(/\A(?<key>\w+)=\z/)) && self.rules.keys.include?(match[:key].to_sym)
        set match[:key], args.first
      else
        super method, *args, block
      end
    end

    private

    def set(key, value)
      self.rules.check(key, value)
      instance_variable_set "@#{key}", value
    end

    def get(key)
      if instance_variable_defined?("@#{key}")
        instance_variable_get "@#{key}"
      else
        self.rules[key.to_sym][:default]
      end
    end
  end
end
