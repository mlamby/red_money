require 'indicator'

require 'red_money/meta/has_parameters'
require 'red_money/system_base'
require 'red_money/position'
require 'red_money/bar'
require 'red_money/portfolio'
require 'red_money/execution/system_steps'

require 'red_money/data_source/data_source'
require 'red_money/data_source/yahoo_finance_source'

RedMoney::DataSource.register :yahoo_finance, RedMoney::YahooFinanceSource
RedMoney::DataSource.set_default :yahoo_finance
