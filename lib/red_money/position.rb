module RedMoney
  # Position class
  # Example:
  # p = Position.new # Position will default to :none
  # To set the position to :short call p.short()
  # To set the position to :long call p.long()
  # To set the position to :none call p.none()
  # Check the position call, is_long?, is_short?, is_none?
  # or call p.direction which will return one of :long, :short or :none
  class Position
      
    # Direction is one of either :long, :short: or :none
    attr_accessor :direction
    
    # Initialize the position. Defaults to :none.
    # The d argument allows a different position to be set
    def initialize(d=:none)
      positions = [:long, :short, :none]
      positions.each do |dir|
        self.class.send(:define_method, "is_#{dir}?") do
          @direction == dir
        end
        self.class.send(:define_method, dir) do
          @direction = dir
        end
      end
      
      @direction = positions.include?(d) ? d : :none
    end
    
    def to_s
      "Position: direction=#{@direction}"
    end
  end
end
