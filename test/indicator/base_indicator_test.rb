require 'test/unit'
require 'indicator'

include Indicator

# Test class 
class Square
  attr_accessor :x, :y
  attr_accessor :results
  
  def initialize x,y
    @x = x
    @y = y
    @results = {}
  end
  
  def area
    @x*@y
  end
  
  def to_f
    @x
  end
  
  def result name, value
    @results[name] = value
  end
end

class Halver < BaseIndicator
  def initialize name
    super name, 0
  end
  
  def process_array data
    input_array = pre_process data
    results = fill_unstable_period input_array
    
    for i in input_array
      add_result results, i, @getter.call(i)/2.0 
    end
    
    post_process results
  end
end

class BaseIndicatorTest < Test::Unit::TestCase

  def setup
    @data = []
    (1..5).each { |x| @data << x }
    
    @data << 4
    @data << 5
    @data << 4
    @data << 5
    
    @period_5 = BaseIndicator.new 'test', 5
    
    @squares = []
    (1..10).each do |i|
      @squares << Square.new(i,i)
    end
  end
  
  def test_defaults
    assert_equal @period_5.should_reverse, false
    assert_equal @period_5.skip_length, 0
    assert_equal @period_5.check_length, true
  end
  
  def test_opts
    i = nil
    
    assert_nothing_raised do
      i = BaseIndicator.new 'test', 5, 
      {
        :should_reverse => true,
        :skip_length => 7,
        :check_length => true
      }
    end
    
    assert_equal true, i.should_reverse
    assert_equal 7, i.skip_length
    assert_equal true, i.check_length
  end
  
  def test_pre_process
  
    @period_5.should_reverse = false
    @period_5.skip_length = 0
    input_array = @period_5.pre_process @data
    assert_equal [1,2,3,4,5,4,5,4,5], input_array
    
    @period_5.should_reverse = true
    input_array = @period_5.pre_process @data
    assert_equal [5,4,5,4,5,4,3,2,1], input_array
    
    @period_5.should_reverse = true
    @period_5.skip_length = 3
    input_array = @period_5.pre_process @data
    assert_equal [4,5,4,3,2,1], input_array
    
    @period_5.should_reverse = false
    @period_5.skip_length = 3
    input_array = @period_5.pre_process @data
    assert_equal [4,5,4,5,4,5], input_array
      
    assert_nothing_raised do
      @period_5.check_length = true
      @period_5.pre_process @data
    end
    
    assert_raises ArgumentError do
      @period_5.check_length = true
      @period_5.pre_process [1,2,3]
    end
    
    assert_nothing_raised do
      @period_5.check_length = true
      @period_5.skip_length = 3
      @period_5.pre_process @data
    end
    
    assert_raises ArgumentError do
      @period_5.check_length = true
      @period_5.skip_length = 8
      @period_5.pre_process @data
    end
  end  
  
  def test_fill_unstable_period
    results = @period_5.fill_unstable_period @data
    assert_equal [nil,nil,nil,nil], results
  end
  
  def test_getter
    sq = Square.new 3,4
    assert_equal @period_5.getter.call(sq), 3
    @period_5.getter = nil
    assert_equal @period_5.getter.call(sq), 3
    
    @period_5.getter = :area
    assert_equal @period_5.getter.call(sq), 12   
    
    @period_5.getter = :y
    assert_equal @period_5.getter.call(sq), 4
    
    @period_5.getter = lambda { |s| (s.x * 2) + (s.y * 2)}
    assert_equal @period_5.getter.call(sq), 14
  end
  
  def test_setter
    half = Halver.new 'test'
    half.setter = :result 
    
    results = half.process_array @squares
    assert_equal [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5], results
    
    for s in @squares
      assert_equal s.to_f/2.0, s.results['test']
    end
  end
end
