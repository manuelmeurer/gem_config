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
        set key, nil
      end
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
      self.instance_variable_set "@#{key}", value
    end

    def get(key)
      self.instance_variable_get("@#{key}") || self.rules[key.to_sym][:default]
    end
  end
end
