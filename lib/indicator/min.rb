module Indicator
  class Min < BaseIndicator
    attr_reader :period
    
    def initialize name, period
      super name, period
      @period = period
    end
    
    def process_array data
      input_array = pre_process data, @period
      results = fill_unstable_period input_array
   
      # Do the Min calculations   
      input_array.each_cons(@period) do |d| 
        result = d.collect{ |x| @getter.call(x)}.min
        add_result results, d.last, result
      end
      
      post_process results
    end
  end
end
