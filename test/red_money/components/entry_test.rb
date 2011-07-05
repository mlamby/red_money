require 'test/unit'
require 'red_money'
require 'cross_over_entry'

include RedMoney

class SimpleEntry < SystemBase
  parameter :delta

  def entry(bar, position)
    return if bar.open == 0.0

    diff = (bar.close - bar.open) / bar.open
    position.long if diff > self.delta 
  end
end

class EntryTest < Test::Unit::TestCase

  def setup
    @b = Bar.new
  end

  def test_simple_class
    simple = SimpleEntry.new
    simple.delta = 1

    @b.open = 1.0
    @b.close = 1.5
    pos = SystemSteps.step_entry simple, @b
    assert_equal true, pos.is_none?
    
    @b.open = 1.0
    @b.close = 3.0
    pos = SystemSteps.step_entry simple, @b
    assert_equal true, pos.is_long?
  end

  def test_cross_over
    sys = Examples::CrossOverEntry.new
    sys.reset

    @b.indicator :sma_fast, 10 
    @b.indicator :sma_slow, 5

    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_long?
    
    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_none?
    
    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_none?
    
    @b.indicator :sma_fast, 9
    @b.indicator :sma_slow, 10
    
    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_short?
    
    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_none?
    
    pos = SystemSteps.step_entry sys, @b
    assert_equal true, pos.is_none?
  end
end
