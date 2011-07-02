require 'test/unit'
require 'red_money'

include RedMoney

class PositionTest < Test::Unit::TestCase

  def test_default
    pos = Position.new

    assert_equal :none, pos.direction
  end

  def test_long
    pos = Position.new
    assert_equal :none, pos.direction

    pos.long
    assert_equal :long, pos.direction
    assert_equal true, pos.is_long?
    assert_equal false, pos.is_short?
    assert_equal false, pos.is_none?
  end
  
  def test_short
    pos = Position.new
    assert_equal :none, pos.direction

    pos.short
    assert_equal :short, pos.direction
    assert_equal false, pos.is_long?
    assert_equal true, pos.is_short?
    assert_equal false, pos.is_none?
  end
  
  def test_none
    pos = Position.new :long
    assert_equal :long, pos.direction

    pos.none
    assert_equal :none, pos.direction
    assert_equal false, pos.is_long?
    assert_equal false, pos.is_short?
    assert_equal true, pos.is_none?
  end
end
