module RedMoney
  module SystemSteps
    def self.step_entry component, bar
      position = Position.new
      
      if component.has_entry?
        component.send(:entry, bar, position)
      end

      position
    end

    def self.step_allow_order component, folio, order
      if component.has_allow_order?
        component.send(:allow_order, folio, order)
      end
      order
    end
  end
end
