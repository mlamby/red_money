require 'test/unit'
require 'indicator'

include Indicator

class Array
  include HasIndicators
end

class Point
  attr_accessor :left, :right, :result
  
  def initialize(l, r)
    @left = l
    @right = r
    @result = nil
  end
end

class HasIndicatorsMixinTest < Test::Unit::TestCase

  def test_simple
    i = [1,2,3,4,5]
    i.setup_has_indicator_mixin
    puts "Running Indicator"
    assert_equal [nil, nil, 2, 3, 4],  i.run_indicator(:sma_3)
  end
  
  def test_getter
    data = []
    data.setup_has_indicator_mixin
    for i in (1..5)
      data << Point.new(i, i * 5)
    end
    
    data.getter = :left
    assert_equal [nil, nil, 2, 3, 4],  data.run_indicator(:sma_3)
    
    data.getter = :right
    assert_equal [nil, nil, 10, 15, 20],  data.run_indicator(:sma_3)
    
    data.getter = lambda {|d| (d.right / 5) + 1 }
    assert_equal [nil, nil, 3, 4, 5],  data.run_indicator(:sma_3)
  end

end
