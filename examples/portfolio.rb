require 'red_money'

p = RedMoney::Portfolio.new do
  name :Tradeables

  symbol :NAB, :AX
  symbol :CBA, :AX
  symbol :WOW, :AX

  indicator :ema_13
  indicator :ema_25
  indicator :max_10
end

# Retrieve the symbol data from the default source
p.update_symbol_data

# Run all the indicators over the data
p.run_indicators

# Print out some info
puts "Date,Close,EMA_13,EMA_25,MAX_10"
p[:NAB].each do |bar|
  puts "#{bar.date}, #{bar.close}, #{bar.ema_13}, #{bar.ema_25}, #{bar.max_10}"
end
