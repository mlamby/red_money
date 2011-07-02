require 'red_money'

module Examples

  # A simple entry component that runs two simple moving averages.
  # When the fast one crosses above the slow one a long entry signal is
  # triggered. When the fast one crosses below the slow one a short
  # entry signal is generated.
  # TODO: Add a re-usable crossing detector.
  class CrossOverEntry < RedMoney::SystemBase
    parameter :fast_period, 9
    parameter :slow_period, 13

    # Create an sma indicator that uses the :fast_period
    # parameter as it's period.
    indicator :sma_fast, :fast_period

    # Create an sma indicator the uses the :slow_period
    # parameter as it's period
    indicator :sma_slow, :slow_period

    # Initialise the component
    def reset
      @last = :none 
    end

    # Do the entry calculations
    def entry(bar, position)
      long = bar.sma_fast > bar.sma_slow
      short = bar.sma_fast < bar.sma_slow

      position.long if long and not @last == :long
      position.short if short and not @last == :short

      @last = position.direction unless position.is_none?
    end
  end
end
