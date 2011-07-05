require 'red_money'

# This sample is not executable at the moment
module Examples
  class SimpleRiskManager < RedMoney::SystemBase

    # Determine if the supplied order is allowed to proceed 
    def allow_order folio, order
      
      # Only one position in a certain stock is allowed to be open at once
      # TODO: Decide if the portfolio is the best place to store open
      # orders. Possibly create a system data object or simlar.
      if folio.orders.contains? order.symbol
        order.reject "Position already open for #{trade.symbol}"
      end
     
    end
  end
end

