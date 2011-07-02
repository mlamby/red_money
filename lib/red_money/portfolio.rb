require 'date'

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
      @symbols[symbol][:data]
    end
    
    def []=(symbol, value)
      @symbols[symbol][:data] = value
    end
    
    def run_indicators
      @symbols.each_value do |s|
        indicator_names.each { |i| run_indicator i, s[:data] }
      end
    end
    
    def name(value)
      @name = value
    end

    # Retrieves the data for each symbol using the specified
    # or default data source.
    def update_symbol_data days=365, to_date=Date.today
      @symbols.each_key do |s|
        DataSource.update @symbols[s], days, to_date
      end
    end
    
    # DSL Functions
    #---------------
    def with(&block)
      instance_eval(&block) if block_given?
    end
    
    def indicator(name)
      add_indicator name
    end
    
    def symbol(name, exchange=nil, source=:default)
      name = name.to_sym
      unless @symbols.has_key? name
        @symbols[name] = {}
        @symbols[name][:name] = name
        @symbols[name][:data] = []
        @symbols[name][:source] = source 
        @symbols[name][:exchange] = exchange 
      end
    end
  end

end
