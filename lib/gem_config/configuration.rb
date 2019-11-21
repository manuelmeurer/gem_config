module GemConfig
  class Configuration
    def initialize(parent = nil)
      @parent = parent
    end

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
      call_after_configuration_change
    end

    def method_missing(method, *args, &block)
      case
      when self.rules.keys.include?(method.to_sym)
        get method
      when (match = method.to_s.match(/\A(?<key>\w+)=\z/)) && self.rules.keys.include?(match[:key].to_sym)
        set match[:key], args.first
      else
        super
      end
    end

    private

    def set(key, value)
      self.rules.check(key, value)
      instance_variable_set "@#{key}", value
      call_after_configuration_change
      value
    end

    def get(key)
      case
      when instance_variable_defined?("@#{key}")
        instance_variable_get "@#{key}"
      when self.rules[key.to_sym].key?(:default)
        set key, self.rules[key.to_sym][:default]
      end
    end

    def call_after_configuration_change
      unless @parent.nil?
        after_configuration_change = @parent.instance_variable_get(:@after_configuration_change)
        after_configuration_change.call unless after_configuration_change.nil?
      end
    end
  end
end
