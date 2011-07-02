require 'red_money'

module Examples
  class CrossOverEntry < RedMoney::SystemBase
    parameter :fast_period, 9
    parameter :slow_period, 13

    indicator :sma_fast, :fast_period
    indicator :sma_slow, :slow_period

    def reset
      @last_position = RedMoney::Position.new
    end

    def entry(bar, position)
      long = bar.sma_fast > bar.sma_slow
      short = bar.sma_fast < bar.sma_slow

      position.long if long and not @last_position.is_long? 
      position.short if short and not @last_position.is_short?

      @last_position.direction = position.direction unless position.is_none?
    end
  end
end
