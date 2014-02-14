module GemConfig
  class Rules < Hash
    def has(key, attrs = {})
      check_attributes attrs
      self[key.to_sym] = attrs
    end

    def check(key, value)
      error_message = case
      when !self.has_key?(key.to_sym)
        'no rule found'
      when self[key.to_sym].has_key?(:classes) && Array(self[key.to_sym][:classes]).none? { |klass| value.is_a?(klass) }
        "must be an instance of one of the following classes: #{Array(self[key.to_sym][:classes]).join(', ')}"
      when self[key.to_sym].has_key?(:values) && !Array(self[key.to_sym][:values]).include?(value)
        "must be one of the following values: #{Array(self[key.to_sym][:values]).join(', ')}"
      end
      raise InvalidKeyError, "#{value} is not a valid value for #{key}: #{error_message}" unless error_message.nil?
    end

    private

    def check_attributes(attrs)
      allowed_keys = [:classes, :values, :default]
      attrs.keys.each do |k|
        raise ArgumentError, %("#{k}" is not a valid attribute. Valid attributes are: #{allowed_keys.join(', ')}) unless allowed_keys.include?(k)
      end

      if attrs.has_key?(:classes)
        other_than_class = Array(attrs[:classes]).any? do |value|
          !value.is_a?(Class)
        end
        raise ArgumentError, 'Value of :classes parameter must be a single class or an array of classes.' if other_than_class
      end

      if attrs.has_key?(:classes) && attrs.has_key?(:values)
        value_not_in_classes = Array(attrs[:values]).any? do |value|
          Array(attrs[:classes]).none? do |klass|
            value.is_a?(klass)
          end
        end
        raise ArgumentError, 'Values of :values parameter must all have the type of one of the defined :classes.' if value_not_in_classes
      end

      if attrs.has_key?(:default)
        if attrs.has_key?(:classes)
          default_not_in_classes = Array(attrs[:classes]).none? do |klass|
            attrs[:default].is_a?(klass)
          end
          raise ArgumentError, 'Value of :default parameter must have the type of one of the defined :classes.' if default_not_in_classes
        end

        if attrs.has_key?(:values)
          default_not_in_values = !Array(attrs[:values]).include?(attrs[:default])
          raise ArgumentError, 'Value of :default parameter must have the type of one of the defined :values.' if default_not_in_values
        end
      end
    end
  end
end
