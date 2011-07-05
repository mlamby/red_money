require 'red_money'

# This sample is not executable at the moment
module Examples
  class SimpleRiskManager < RedMoney::SystemBase

    # Determine if the supplied order is allowed to proceed 
    def allow_order folio, order
      
      # Only one position in a certain stock is allowed to be open at once
      if folio.order.contains? order.symbol
        order.reject "Position already open for #{trade.symbol}"
      end
     
    end
  end
end

