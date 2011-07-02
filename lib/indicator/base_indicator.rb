module Indicator
  class BaseIndicator
    attr_accessor :should_reverse, :check_length, :name
    attr_reader :unstable_period, :skip_length
    attr_reader :getter, :setter
    
    def initialize name, unstable_period, opts={}
      @name = name
      @getter = lambda { |d| d.to_f}
      @setter = nil
      @should_reverse = false
      @skip_length = 0
      @check_length = true
      
      unless unstable_period >= 0
        raisee ArgumentError.new("unstable_period must be greater than or equal to zero")
      end
      
      @unstable_period = unstable_period
      
      opts.each do |k,v|
        sym = "#{k}=".to_sym
        self.send sym, v if self.respond_to? sym
      end
    end
    
    def pre_process data, minimum_length=@unstable_period
      # Perform some basic argument checks
      unless data.is_a? Enumerable
        raise ArgumentError, "data must be enumerable" 
      end
    
      input_array = data
      
      # Apply the options
      input_array = input_array.reverse if @should_reverse
      input_array = input_array.drop @skip_length if @skip_length > 0
      
      # Check the lenght of the list
      if @check_length and input_array.length < minimum_length
        raise ArgumentError, 
          "Not enough data. #{minimum_length} elements required."
      end
      
      input_array
    end
    
    def add_result results, element, value
      unless @setter.nil?
        @setter.call(element, @name, value)
      end
      results << value
    end
    
    def post_process results
      # No processing defined - just reuturn the passed in data
      results
    end
    
    def fill_unstable_period input_array
      results = []
      
      if @unstable_period > 0
        # If a indicator has an unstable period of 5 then then first 4 results
        # will be nill.
        for i in input_array.first(@unstable_period-1) do
          add_result results, i, nil
        end
      end
      
      results
    end
    
    def skip_length= length
      unless length >= 0 
        raise ArgumentError, "length must be greater than or equal to zero" 
      end
      
      @skip_length = length
    end
    
    def getter= func_or_sym
      if func_or_sym.nil?
        # Use a default if no getter was defined
        @getter = lambda { |e| e.to_f}
      else
        @getter = 
          func_or_sym.respond_to?(:call) ? func_or_sym : func_or_sym.to_proc
      end 
    end
    
    def setter= sym
      unless sym.nil?
        sym = sym.to_sym
        @setter = lambda { |e,name,value| e.send(sym, name, value)}
      end
    end
  end
end
