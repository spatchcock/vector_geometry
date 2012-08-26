module Math

  class Function

    attr_accessor :place_holders

    def initialize(options={},&block)
      if block_given?
        @function = block 
        @variable = nil
        @place_holders = []
        initialize_place_holders &block
      else
        raise ArgumentError, "No block given"
      end
      
      set options unless options.empty?
    end

    def variable
      @variable
    end

    def variable=(symbol_or_string)
      raise ArgumentError, "#{symbol_or_string} is not a valid variable. Must be one of #{@place_holders.join(",")}" unless is_place_holder?(symbol_or_string)
      @variable = symbol_or_string.to_sym
    end

    def parameters
      @place_holders.reject {|p| p == @variable }
    end

    def set(options={})
      options.each { |var,value| self.send("#{var}=",value) }
      return self
    end

    def evaluate(options={})
      set options unless options.empty?
      instance_eval(&@function)
    end

    def distribution(range=[],options={})
      raise ArgumentError, "range is not an Array or Range object" unless range.is_a?(Array) || range.is_a?(Range)

      set options unless options.empty?

      Distribution.new do |distribution|
        distribution.x = range.to_a
        distribution.y = distribution.x.map do |x| 
          set(variable => x) if @variable
          evaluate
        end
      end
    end

    def integrate(from,to,delta,options={})
      scale = Distribution.scale(from,to,delta)
      distribution(scale,options).integrate
    end

    def absolute_difference(target,options={})
      set options unless options.empty?
      (evaluate - target).abs
    end

    protected

    UNDEFINED_VARIABLE_REGEX = /undefined local variable or method `(.*)'/

    def initialize_place_holders(&block)
      value = nil
      until value.is_a?(Numeric) do
        begin
          value = instance_eval(&block)
        rescue => error

          if UNDEFINED_VARIABLE_REGEX.match(error.inspect)
            initialize_place_holder($1)
          else
            string =  "WARNING: This exception may have been generated because the stated function uses "
            string += "one of the following reserved phrases as a placeholder #{methods.join(",")}.\n\n"
            string += "Please check the function for invalid placeholders."

            raise error.exception(error.message + "\n\n" + string)
          end
        end
      end
    end

    def initialize_place_holder(string)
      @place_holders << string.to_sym
      instance_variable_set("@#{string}", 1)
      define_singleton_method(string.to_sym) { instance_variable_get("@#{string}") }
      define_singleton_method("#{string}=")  { |val| instance_variable_set("@#{string}",val) }
    end

    def is_place_holder?(string_or_symbol)
      @place_holders.include?(string_or_symbol.to_sym)
    end

  end

end