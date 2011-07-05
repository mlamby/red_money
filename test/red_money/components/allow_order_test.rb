require 'test/unit'
require 'red_money'
require 'simple_risk_manager'

include RedMoney

class SimpleAllowOrder < SystemBase
  def allow_order folio, order
    order.reject 'No Real Reason' if order.symbol == :CBA
  end
end

class AllowOrderTest < Test::Unit::TestCase

  def setup
    @folio = Portfolio.new
    @bar = Bar.new
    @position = Position.new :long
  end

  def test_simple_allow_order
    c = SimpleAllowOrder.new
    
    @bar.symbol = :NAB
    o = Order.new @bar, @position
    SystemSteps.step_allow_order c, @folio, o
    assert_equal false, o.is_rejected? 
    
    @bar.symbol = :CBA
    o = Order.new @bar, @position
    SystemSteps.step_allow_order c, @folio, o
    assert_equal true, o.is_rejected? 
  end

  def test_complex
    c = Examples::SimpleRiskManager.new
    
    @bar.symbol = :NAB
    o = Order.new @bar, @position
#    SystemSteps.step_allow_order c, @folio, o

  end
end
