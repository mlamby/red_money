module RedMoney

  module DefinesIndicators

    def self.included source
      source.extend ClassMethods
    end

    # Returns a list of indicators defined by this module instance
    def indicators
      self.class.indicators
    end

    def create_indicators portfolio
      indicators.each do |name,opts|
        args = opts[1]

        # Loop through each argument and if any are symbols that 
        # match a parameter defined for this object then use the parameter
        # value instead.
        args.collect! { |a| parameters.has_key?(a) ? parameters[a] : a }

        # Add the indicator to the passed in portfolio
        portfolio.add_indicator name, opts[0], args
      end
    end

    module ClassMethods
      def indicator name, type=:inferred, args=nil
        indicators[name] = [type, args] 
      end

      def indicators
        @indicators ||= {}
      end
    end
  end
end
