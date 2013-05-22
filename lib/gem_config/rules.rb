require 'active_support/core_ext/hash/keys'

module GemConfig
  class Rules < Hash
    def has(key, attrs = {})
      check_attributes attrs
      self[key.to_sym] = attrs
    end

    private

    def check_attributes(attrs)
      attrs.assert_valid_keys :classes, :values, :default

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
          raise ArgumentError, 'Value of :default parameter must have the type of one of the defined :classes.' if default_not_in_values
        end
      end
    end
  end
end
