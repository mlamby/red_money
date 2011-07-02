require 'yahoofinance'
require 'date'

module RedMoney
  module YahooFinanceSource
    Indexes = {
      :date           => 0,
      :open           => 1,
      :high           => 2,
      :low            => 3,
      :close          => 4,
      :volume         => 5,
      :adjusted_close => 6
    }

    def self.update symbol, days, to_date
      ticker = "#{symbol[:name]}"
      exchange = symbol[:exchange]
      ticker = ticker + ".#{exchange}" unless exchange.nil? 
      from = to_date - days
      raw = YahooFinance::get_historical_quotes(ticker, from, to_date)
      raw.reverse.collect { |r| create_bar r }
    end 

    def self.create_bar raw
      Bar.new( {
        :open => raw[Indexes[:open]].to_f,
        :high => raw[Indexes[:high]].to_f,
        :low => raw[Indexes[:low]].to_f,
        :close => raw[Indexes[:close]].to_f,
        :volume => raw[Indexes[:volume]].to_f,
        :date => Date.parse(raw[Indexes[:date]])
      })
    end
  end
end
