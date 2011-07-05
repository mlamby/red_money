require 'red_money'

# This sample is not executable at the moment

module RedMoney
  class Order
    attr_reader :bar
    attr_reader :symbol
    attr_reader :rejection_reason
    attr_reader :position
    
    def initialize bar, position
      @bar = b
      @symbol = b.symbol
      @rejection_reason = nil
      @position = position
    end

    def reject reason
      @rejection_reason = reason
    end

    def is_rejected?
      not @rejection_reason.nil?
    end
  end
end

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

