module Indicator
  class Ema < BaseIndicator
    attr_reader :period
    
    def initialize name, period
      super name, period
      @period = period
    end
    
    def process_array data
      input_array = pre_process data, @period
      results = fill_unstable_period input_array
      
      # Calculate the seed using a simple average of the first data period
      unstable_data = input_array.take(@period)
      last_result = input_array.take(@period).inject(0.0) { 
        |sum, i| sum + getter.call(i)} / @period
      
      add_result results, unstable_data.last, last_result
      
      # Lambda which does the actual calculation
      k_1 = 2.0 / (@period + 1.0)
      calc = ->(c,l) { (c - l) * k_1 + l }
      
      # Drop the data used for the initial seed and perform
      # the calculations for each sucessive element
      input_array.drop(@period).each do |i|
        last_result = calc.call(@getter.call(i), last_result)
        add_result results, i, last_result
      end
      
      post_process results
    end
  end
end
