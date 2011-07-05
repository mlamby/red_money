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

