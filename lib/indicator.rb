require 'indicator/base_indicator'
require 'indicator/factory.rb'
require 'indicator/has_indicators.rb'
require 'indicator/ema.rb'
require 'indicator/sma.rb'
require 'indicator/max.rb'
require 'indicator/min.rb'

# Register all the indicators
Indicator::Factory.register Indicator::Ema
Indicator::Factory.register Indicator::Sma
Indicator::Factory.register Indicator::Max
Indicator::Factory.register Indicator::Min
