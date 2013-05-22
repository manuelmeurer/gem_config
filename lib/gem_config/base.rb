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
        @configuration ||= Configuration.new
      end

      def with_configuration(&block)
        configuration.rules.instance_eval(&block)
      end
    end
  end
end
