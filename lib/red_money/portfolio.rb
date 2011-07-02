module RedMoney

  class Portfolio
    include Indicator::HasIndicators
    
    attr_accessor :name, :symbols
    
    def initialize(name = '',&block)
      @name = name     
      @symbols = {}
      
      # Setup default indicator mixin properties
      setup_has_indicator_mixin
      @setter = :indicator
      @getter = :close
      
      with(&block)
    end
    
    def [](symbol)
      @symbols[symbol]
    end
    
    def []=(symbol, value)
      @symbols[symbol] = value
    end
    
    def run_indicators
      @symbols.each_value do |s|
        indicator_names.each { |i| run_indicator i, s }
      end
    end
    
    def name(value)
      @name = value
    end
    
    # DSL Functions
    #---------------
    def with(&block)
      instance_eval(&block) if block_given?
    end
    
    def indicator(name)
      add_indicator name
    end
    
    def symbol(name)
      name = name.to_sym
      unless @symbols.has_key? name
        @symbols[name] = []
      end
    end
  end

end
