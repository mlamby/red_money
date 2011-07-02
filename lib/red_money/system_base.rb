module RedMoney
  class SystemBase
    include HasParameters

    class << self  
      def indicator name, args=nil, type=:inferred 
        indicators[name] = [type, args] 
      end

      def indicators
        @indicators ||= {}
      end
    end
    
    # Returns a list of indicators defined by this system 
    def indicators
      self.class.indicators
    end

    # Add the indicators defined by this system to the given portfolio
    def add_indicators portfolio
      indicators.each do |name,opts|
        args = opts[1]

        # Loop through each argument and if any are symbols that 
        # match a parameter defined for this object then use the parameter
        # value instead.
        unless args.nil?
          args = Array(args)
          args.collect! { |a| parameters.has_key?(a) ? parameter(a) : a }
        end

        # Add the indicator to the passed in portfolio
        portfolio.add_indicator name, opts[0], args
      end
    end

    # Does this system component have an entry method
    def has_entry?
      self.respond_to? :entry
    end
  end
end
