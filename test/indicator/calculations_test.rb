require 'test/unit'
require 'indicator'

include Indicator

class CalculationsTest < Test::Unit::TestCase
  
  def setup
    @data = []
    (1..5).each { |x| @data << x }
    
    @data << 4
    @data << 5
    @data << 4
    @data << 5
  end
  
  def test_sma
    sma = Sma.new 'sma', 5
    assert_equal [nil, nil, nil, nil, 3.0, 3.6, 4.2, 4.4, 4.6], 
      sma.process_array(@data)
    
    sma = Sma.new 'sma', 3
    assert_equal [nil, nil, 2, 3, 4, 4.0+1.0/3.0, 4.0+2.0/3.0, 4.0+1.0/3.0, 4.0+2.0/3.0], 
      sma.process_array(@data)
  end
  
  def test_ema
    ema = Ema.new 'ema', 1
    assert_equal [1, 2, 3, 4, 5, 4, 5, 4, 5], ema.process_array(@data)
    
    ema = Ema.new 'ema', 3
    assert_equal [nil, nil, 2, 3, 4, 4, 4.5, 4.25, 4.625], 
      ema.process_array(@data)
  end
  
  def test_max
    max = Max.new 'max', 3
    assert_equal [nil, nil, 3, 4, 5, 5, 5, 5, 5], max.process_array(@data)
    
    max = Max.new 'max', 3
    max.should_reverse = true
    assert_equal [nil, nil, 5, 5, 5, 5, 5, 4, 3], max.process_array(@data)
  end
  
  def test_min
    min = Min.new 'min', 3
    assert_equal [nil, nil, 1, 2, 3, 4, 4, 4, 4], min.process_array(@data)
  end
end
