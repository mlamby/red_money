module RedMoney

  # When this module is included in a class it allows the class to define
  # parameters.
  # 
  # Class Test
  #   include HasParameters
  #
  #   parameter :one, 1
  #   parameter :two, 2
  #
  #   def print_info
  #     puts "one=#{one}, two=#{two}"
  #   end
  # End
  #
  # t = Test.new
  # t.print_info
  # > one=1, two=2
  #
  # t.one = 5
  # t.print_info
  # > one=5, two=2
  #
  module HasParameters 
    def self.included source
      source.extend ClassMethods
    end

    def reset_parameters
      @parameters = {}
      self.class.parameter_names.each do |pa|
        self.send "#{pa}_reset"
      end
    end

    def parameters
      reset_parameters if @parameters.nil?  
      @parameters 
    end

    def has_parameter? name
      parameters.has_key? name
    end

    def parameter name
      # Call the predefined getter
      self.send(name)
    end

    module ClassMethods
      # Creates a class method that can be used to add parameters to
      # the containing class
      # eg parameter :limit, 100.0
      def parameter name, default=0.0

        parameter_names << name

        # Create the getter
        define_method(name) { parameters[name] }

        # Create the setter
        define_method("#{name}=") { |v| parameters[name] = v }

        # Create a getter for the default value
        define_method("#{name}_default") { default }

        # Reset the parameter
        define_method("#{name}_reset") { @parameters[name] = default }
      end

      def parameter_names
        @parameter_names ||= []
      end
    end
  end
end
