require 'date'

module RedMoney
  class Bar
    attr_accessor :open, :high, :low, :close, :volume, :symbol
    attr_reader :date
    
    def initialize(args={})
      @symbol = args[:symbol] 
      @open = args[:open] || 0.0
      @high = args[:high] || 0.0
      @low = args[:low] || 0.0
      @close = args[:close] || 0.0
      @volume = args[:volume] || 0.0
      d = args[:date] || DateTime.now      
      @date = d.is_a?(String) ? DateTime.parse(d) : d
      @indicators = {}
    end
    
    def to_s
      return "d=#{@date},o=#{@open},h=#{@high},l=#{@low},c=#{@close},v=#{@volume}"
    end
    
    # Custom date setter.
    # Allows the date value to be set using either a string
    # or DateTime object
    def date=(value)
      @date = value.is_a?(String) ? DateTime.parse(value) : value
    end
    
    # A bar can be indexed using a symbol or string.
    # The case is ignored. Example:
    #   b = Bar.new()
    #   b[:open]
    #   b["open"]
    def [](index)
      method_name = "#{index.to_s.downcase}"
      raise KeyError.new("Unkown index: #{index}") unless respond_to? method_name
      send method_name
    end
    
    # A bar can be indexed using a symbol or string.
    # The case is ignored. Example:
    #   b = Bar.new()
    #   b[:open] = 100.0
    #   b["open"] = 10.0
    def []=(index, value)
      method_name = "#{index.to_s.downcase}="
      raise KeyError.new("Unkown index: #{index}") unless respond_to? method_name
      send method_name, value
    end
    
    # Set the specified indicator value
    def indicator name, value
      @indicators[name.to_s] = value
    end
    
    def method_missing(sym, *args, &block)
      return @indicators[sym] if @indicators.has_key? sym
      return @indicators[sym.to_s] if @indicators.has_key? sym.to_s
      super(sym, *args, &block)
    end
  end
end
