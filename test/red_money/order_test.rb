require 'test/unit'
require 'red_money'

include RedMoney

class OrderTest < Test::Unit::TestCase

  def setup
    @bar = Bar.new
    @bar.symbol = :test

    @position = Position.new :long

    @order = Order.new @bar, @position
  end

  def test_defaults
    assert_equal @bar, @order.bar
    assert_equal @position, @order.position
    assert_equal :test, @order.symbol
    assert_equal false, @order.is_rejected?
    assert_equal nil, @order.rejection_reason
  end

  def test_rejection
    assert_equal false, @order.is_rejected?

    @order.reject 'This order is no good'

    assert_equal true, @order.is_rejected?
    assert_equal 'This order is no good', @order.rejection_reason
  end
end
