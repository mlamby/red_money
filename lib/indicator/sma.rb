module Indicator
  class Sma < BaseIndicator
    attr_reader :period
    
    def initialize name, period
      super name, period
      @period = period
    end
    
    def process_array data
      input_array = pre_process data, @period
      results = fill_unstable_period input_array
   
      # Do the SMA calculations   
      input_array.each_cons(@period) do |d| 
        value = d.inject(0.0) { |sum, i| sum + getter.call(i)} / d.length
        add_result results, d.last, value
      end
      
      post_process results
    end
  end
end
