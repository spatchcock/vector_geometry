class Function

  def initialize(*params,&block)
    value = nil
    until value.is_a?(Numeric) do
      begin
        value = instance_eval(&block)
      rescue => e
        if /undefined local variable or method `(.*)'/.match(e.inspect)
          initialize_parameter_or_variable($1)
        else
          raise e
        end
      end
    end

    @function = block if block_given?
  end

  def initialize_parameter_or_variable(string)
    instance_variable_set("@#{string}", 1)

    define_singleton_method(string.to_sym) do
      instance_variable_get("@#{string}")
    end

    define_singleton_method("#{string}=") do |val| 
      instance_variable_set("@#{string}",val)
    end
  end

  def evaluate(options={},&block)
    options.each {|var,value| self.send("#{var}=",value)}
    yield self if block_given?
    instance_eval(&@function)
  end

  def distribution(options={},&block)
    var,points = options.keys.first, options.values.first

    points.map do |point|
      self.send("#{var}=", point)
      [point, instance_eval(&@function)]
    end
  end

end
