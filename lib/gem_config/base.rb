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
        @configuration ||= Configuration.new(rules)
      end

      def with_configuration(&block)
        rules.instance_eval(&block)
      end

      private

      def rules
        @rules ||= Rules.new
      end
    end
  end
end
