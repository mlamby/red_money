module Indicator
  module HasIndicators
    
    attr_accessor :getter,:setter
    
    def setup_has_indicator_mixin
      @indicator_list ||= []
    end
    
    def add_indicator name, type=:inferred, params=nil      
      i = get_indicator name
      if i.nil?
        if type == :inferred
          @indicator_list << Indicator::Factory.create_named(name, params)
        else
          @indicator_list << Indicator::Factory.create(type, name, params)  
        end
      end
    end
    
    def get_indicator name
      @indicator_list.find { |i| i.name == name} 
    end
    
    def has_indicator? name
      not get_indicator(name).nil?
    end
    
    def indicator_names
      @indicator_list.collect { |i| i.name }
    end
    
    def run_indicator name, data=self
      # Add the indicator if it does not yet exist
      add_indicator name
      
      # Get and run
      i = get_indicator(name)
      i.getter = @getter
      i.setter = @setter

      results = i.process_array data
    end
  end
end
