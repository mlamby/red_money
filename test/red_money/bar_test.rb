require 'test/unit'
require 'red_money'

include RedMoney

class BarTest < Test::Unit::TestCase

  def setup
    @bar = Bar.new( {
      :symbol => :WOW,
      :open => 1.0,
      :high => 2.0,
      :low => 3.0, 
      :close => 4.0,
      :volume => 5.0,
      :date => '1st Feb 2011'
    })
  end
  
  def test_init
    b1 = Bar.new
    
    assert_equal nil, b1.symbol
    assert_equal 0.0, b1.open
    assert_equal 0.0, b1.high
    assert_equal 0.0, b1.low
    assert_equal 0.0, b1.close
    assert_equal 0.0, b1.volume
    assert_equal false, b1.date.nil?
  end
  
  def test_getters
    assert_equal :WOW, @bar.symbol
    assert_equal 1.0, @bar.open
    assert_equal 2.0, @bar.high
    assert_equal 3.0, @bar.low
    assert_equal 4.0, @bar.close
    assert_equal 5.0, @bar.volume
    assert_equal DateTime.parse('1st Feb 2011'), @bar.date
  end
  
  def test_array_getters_and_setters
    @bar[:symbol] = :CBA
    @bar[:open] = 10.0
    @bar[:high] = 20.0
    @bar[:low] = 30.0
    @bar[:close] = 40.0
    @bar[:volume] = 50.0
    @bar[:date] = '16th Jan 1999'
    
    assert_equal :CBA, @bar[:symbol]
    assert_equal 10.0, @bar[:open]
    assert_equal 20.0, @bar[:high]
    assert_equal 30.0, @bar[:low]
    assert_equal 40.0, @bar[:close]
    assert_equal 50.0, @bar[:volume]
    assert_equal DateTime.parse('16th Jan 1999'), @bar[:date]
  end
  
  def test_indicators
    @bar.indicator :one, 1
    assert_equal 1, @bar.one
    
    @bar.indicator 'one', 2
    assert_equal 2, @bar.one
  end
end
