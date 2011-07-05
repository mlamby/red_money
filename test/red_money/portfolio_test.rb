require 'test/unit'
require 'date'
require 'red_money'
require 'red_money/fixed_test_data_source'

include RedMoney

DataSource.register :fixed_test, FixedTestDataSource
DataSource.set_default :fixed_test

class PortfolioTest < Test::Unit::TestCase
  def setup
    @tradeables = Portfolio.new do
      name :tradeables
      
      symbol :WOW
      symbol :CBA, :AX
      symbol :NAB, :AX, :fixed_test
    
      indicator :sma_13
      indicator :ema_25
      indicator :max_10
    end
  end

  def test_name
    assert_equal :tradeables, @tradeables.name
    @tradeables.name = :new_name
    assert_equal :new_name, @tradeables.name
    @tradeables.name :new_name2
    assert_equal :new_name2, @tradeables.name
  end
  
  def test_symbols
    assert_equal true, @tradeables.symbols.has_key?(:WOW)
    assert_equal true, @tradeables.symbols.has_key?(:CBA)
    assert_equal true, @tradeables.symbols.has_key?(:NAB)
    
    assert_equal @tradeables[:WOW], []
    assert_equal @tradeables[:CBA], []
    assert_equal @tradeables[:NAB], []
    
    assert_equal @tradeables.symbols[:WOW][:name], :WOW
    assert_equal @tradeables.symbols[:CBA][:name], :CBA
    assert_equal @tradeables.symbols[:NAB][:name], :NAB
    
    assert_equal @tradeables.symbols[:WOW][:exchange], nil
    assert_equal @tradeables.symbols[:CBA][:exchange], :AX
    assert_equal @tradeables.symbols[:NAB][:exchange], :AX
    
    assert_equal @tradeables.symbols[:WOW][:source], :default
    assert_equal @tradeables.symbols[:CBA][:source], :default
    assert_equal @tradeables.symbols[:NAB][:source], :fixed_test

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

  def test_update_symbol_data
    assert_equal 0, @tradeables[:WOW].count
    assert_equal 0, @tradeables[:CBA].count
    assert_equal 0, @tradeables[:NAB].count
    
    @tradeables.update_symbol_data

    assert_equal 365, @tradeables[:WOW].count
    assert_equal 365, @tradeables[:CBA].count
    assert_equal 365, @tradeables[:NAB].count

    assert_equal Date.today, @tradeables[:WOW].last.date
    assert_equal Date.today-364, @tradeables[:WOW].first.date

    @tradeables.update_symbol_data 10

    assert_equal 10, @tradeables[:WOW].count
    assert_equal 10, @tradeables[:CBA].count
    assert_equal 10, @tradeables[:NAB].count

    assert_equal Date.today, @tradeables[:WOW].last.date
    assert_equal Date.today-9, @tradeables[:WOW].first.date

    to_date = Date.parse('15/12/1983')
    @tradeables.update_symbol_data 20, to_date

    assert_equal 20, @tradeables[:WOW].count
    assert_equal 20, @tradeables[:CBA].count
    assert_equal 20, @tradeables[:NAB].count
    
    assert_equal to_date, @tradeables[:WOW].last.date
    assert_equal to_date - 19, @tradeables[:WOW].first.date
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
