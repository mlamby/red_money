require 'test/unit'
require 'red_money'

include RedMoney

class PortfolioTest < Test::Unit::TestCase
  def setup
    @tradeables = Portfolio.new do
      name :tradeables
      
      symbol :WOW
      symbol :CBA
      symbol :NAB
    
      indicator :sma_13
      indicator :ema_25
      indicator :max_10
    end
  end
  
  def test_symbols
    assert_equal true, @tradeables.symbols.has_key?(:WOW)
    assert_equal true, @tradeables.symbols.has_key?(:CBA)
    assert_equal true, @tradeables.symbols.has_key?(:NAB)
    
    assert_equal @tradeables[:WOW], []
    assert_equal @tradeables[:CBA], []
    assert_equal @tradeables[:NAB], []
  end

  def test_indicators
    assert_equal true, @tradeables.has_indicator?(:sma_13)
    assert_equal true, @tradeables.has_indicator?(:ema_25)
    assert_equal true, @tradeables.has_indicator?(:max_10)
    
    assert_equal Indicator::Sma, @tradeables.get_indicator(:sma_13).class
    assert_equal Indicator::Ema, @tradeables.get_indicator(:ema_25).class
    assert_equal Indicator::Max, @tradeables.get_indicator(:max_10).class
    
    assert_equal 13, @tradeables.get_indicator(:sma_13).period
    assert_equal 25, @tradeables.get_indicator(:ema_25).period
    assert_equal 10, @tradeables.get_indicator(:max_10).period
  end
  
  def test_run_indicators
    @tradeables[:WOW] = bar_generator(100,1)
    @tradeables[:CBA] = bar_generator(100,2)
    @tradeables[:NAB] = bar_generator(100,3)
    @tradeables.run_indicators
  end
  
  def bar_generator count, multiple
    results = []
    for i in (1..count)
      b = Bar.new
      b.close = i * multiple
      results << b
    end
    results
  end
end
