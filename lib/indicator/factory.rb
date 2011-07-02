module Indicator
  module Factory
    
    class UnknownIndicator < StandardError
    end
    
    class NotAnIndicator < StandardError
    end
  
    Available_indicators = {}
    
    # Register an indicator with the factory
    def self.register indicator
      name = indicator.name.split('::').last.downcase.to_sym
      raise NotAnIndicator unless indicator.superclass == Indicator::BaseIndicator
      
      Available_indicators[name] = indicator
    end
    
    def self.get_indicator name
      Available_indicators[name.downcase.to_sym]
    end
   
    # Create the given indicator
    # The type of indicator is inferred from the name.
    # if the name was sma_25 then the type of indicator to create
    # is sma.
    # If params is nil then the arguments to pass to the indicator
    # constructor is inferred from the name also. In the above example
    # a 25 will be passed to the Sma constructor.
    # A name like test_1_2_3 will create an indicator of type Test
    # and pass the values 1, 2, 3 to the constructor.
    def self.create_named name, params=nil
      args = name.to_s.split "_"
      
      # The method name is first
      sym = args.first.to_sym

      # The remaining args are the arguments to pass to the method
      args = params || args.drop(1).collect { |a| a.to_i }
      
      create sym, name, args
    end

    # Create the specified indicator type. 
    def self.create type, name, args
      raise UnknownIndicator,type unless Factory.has_indicator? type
      klass = get_indicator type
      # Create the new indicator
      klass.send(:new, name, *args)  
    end
    
    def self.has_indicator? name
      Available_indicators.has_key? name.downcase.to_sym
    end
  end
end
