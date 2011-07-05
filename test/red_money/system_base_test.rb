require 'test/unit'
require 'red_money'

include RedMoney

class EmptyBase < SystemBase
end

class Base < SystemBase

  component_name :test_base

  parameter :slow_period, 50.0
  parameter :fast_period, 25.0
  parameter :unused

  # The type and argument of this indicator are derived from the name
  # Type=Sma, Period=25
  indicator :sma_25

  # The type of this indicator is derived from the name the argument is fixed
  # Type=Ema, Period=10
  indicator :ema_1000, 10

  # The type of this indicator is derived from it's name but the argument
  # is taken from the system parameter
  # Type=Sma, Period=<Value of :slow_period parameter>
  indicator :sma_linked, :slow_period

  # The type of this indicator is explicitly specified and the argument
  # is taken from the system parameter
  # Type=Ema, Period=<Value of :fast_period parameter>
  indicator :unrelated_name, :fast_period, :ema
end

class SystemBaseTest < Test::Unit::TestCase

  def setup
    @base = Base.new 
    @empty_base = EmptyBase.new
  end

  def test_name
    assert_equal :test_base, @base.component_name
    assert_equal "EmptyBase", @empty_base.component_name
  end

  def test_parameters
    assert_equal true, @base.has_parameter?(:slow_period)
    assert_equal true, @base.has_parameter?(:unused)
    assert_equal false, @base.has_parameter?(:non_existing)

    assert_equal 50.0, @base.slow_period
    assert_equal 50.0, @base.parameter(:slow_period)
    
    assert_equal 0.0, @base.unused
    assert_equal 0.0, @base.parameter(:unused)

    @base.slow_period = 25.0
    assert_equal 25.0, @base.slow_period
    assert_equal 50.0, @base.slow_period_default

    @base.slow_period_reset
    assert_equal 50.0, @base.slow_period
  end

  def test_indicators
    assert_equal true, @base.indicators.has_key?(:sma_25)
    assert_equal true, @base.indicators.has_key?(:ema_1000)
    assert_equal true, @base.indicators.has_key?(:sma_linked)
    assert_equal true, @base.indicators.has_key?(:unrelated_name)

    pf = Portfolio.new
    @base.add_indicators pf
    assert_equal true, pf.has_indicator?(:sma_25)
    assert_equal true, pf.has_indicator?(:ema_1000)
    assert_equal true, pf.has_indicator?(:sma_linked)
    assert_equal true, pf.has_indicator?(:unrelated_name)
    assert_equal false, pf.has_indicator?(:non_existing)

    assert_equal Indicator::Sma, pf.get_indicator(:sma_25).class
    assert_equal Indicator::Ema, pf.get_indicator(:ema_1000).class
    assert_equal Indicator::Sma, pf.get_indicator(:sma_linked).class
    assert_equal Indicator::Ema, pf.get_indicator(:unrelated_name).class
    
    assert_equal 25, pf.get_indicator(:sma_25).period
    assert_equal 10, pf.get_indicator(:ema_1000).period
    
    assert_equal 50, pf.get_indicator(:sma_linked).period
    assert_equal @base.slow_period, pf.get_indicator(:sma_linked).period
    
    assert_equal 25, pf.get_indicator(:unrelated_name).period
    assert_equal @base.fast_period, pf.get_indicator(:unrelated_name).period
  end
end
