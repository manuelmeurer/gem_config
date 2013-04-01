module GemConfig
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def configure
        yield configuration
      end

      def configuration
        @configuration ||= Configuration.new(configuration_rules)
      end

      def with_configuration(&block)
        configuration_rules.instance_eval(&block)
      end

      private

      def configuration_rules
        @configuration_rules ||= ConfigurationRules.new
      end
    end
  end
end
