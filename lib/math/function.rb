module Math

  def Math.function(&block)
    Math::Function.new(&block)
  end

  class Function

    def initialize(&block)
      value = nil
      until value.is_a?(Numeric) do
        begin
          value = instance_eval(&block)
        rescue => e
          if UNDEFINED_VARIABLE_REGEX.match(e.inspect)
            initialize_parameter_or_variable($1)
          else
            raise e
          end
        end
      end

      @function = block if block_given?
    end

    def set(options={})
      options.each { |var,value| self.send("#{var}=",value) }
      return self
    end

    def evaluate(options={})
      set options
      instance_eval(&@function)
    end

    def distribution(range={},options={})
      raise unless range.is_a?(Hash) && range.size == 1
      variable, range = range.keys.first, range.values.first
      set options

      range.map do |value|
        self.send("#{variable}=", value)
        [value, instance_eval(&@function)]
      end
    end

    protected

    UNDEFINED_VARIABLE_REGEX = /undefined local variable or method `(.*)'/

    def initialize_parameter_or_variable(string)
      instance_variable_set("@#{string}", 1)

      define_singleton_method(string.to_sym) do
        instance_variable_get("@#{string}")
      end

      define_singleton_method("#{string}=") do |val| 
        instance_variable_set("@#{string}",val)
      end
    end

  end
end