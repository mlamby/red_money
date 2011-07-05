require 'date'

module RedMoney
  module FixedTestDataSource

    def self.update symbol, days, to_date
      ticker = "#{symbol[:name]}"
      exchange = symbol[:exchange]
      ticker = ticker + ".#{exchange}" unless exchange.nil? 
      
      result = []
      days.times { |d| result << create_bar(to_date - days + d + 1, d) }
      result
    end 

    def self.create_bar d, v
      Bar.new( {
        :open => v,
        :high => v+1,
        :low => v+2,
        :close => v+3,
        :volume => v+4,
        :date => d
      })
    end
  end
end
