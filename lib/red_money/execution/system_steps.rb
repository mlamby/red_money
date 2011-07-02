module RedMoney
  module SystemSteps
    def self.step_entry component, bar
      position = Position.new
      
      if component.has_entry?
        component.send(:entry, bar, position)
      end

      position
    end
  end
end
