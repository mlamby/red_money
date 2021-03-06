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

      def component_name value=nil
        @component_name = value unless value.nil?
        @component_name ||= self.name
      end
    end
    
    # Returns a list of indicators defined by this system 
    def indicators
      self.class.indicators
    end

    def component_name
      self.class.component_name
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
    
    # Does this system component have an allow order method
    def has_allow_order?
      self.respond_to? :allow_order
    end
  end
end
