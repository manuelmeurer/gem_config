module GemConfig
  class Configuration
    def initialize(configuration_rules)
      @configuration_rules = configuration_rules
    end

    def rules
      @configuration_rules
    end

    def current
      @configuration_rules.keys.each_with_object({}) do |key, hash|
        hash[key] = get(key)
      end
    end

    def reset
      @configuration_rules.keys.each do |key|
        set key, nil
      end
    end

    def method_missing(method, *args, &block)
      case
      when @configuration_rules.keys.include?(method.to_sym)
        get method
      when (match = method.to_s.match(/\A(?<key>\w+)=\z/)) && @configuration_rules.keys.include?(match[:key].to_sym)
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
      self.instance_variable_get("@#{key}") || @configuration_rules[key.to_sym][:default]
    end
  end
end
