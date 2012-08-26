module Math

  class Distribution < Hash

    def self.scale(from,to,delta)
      entries = (to - from)/delta + 1
      Array.new(entries) {|i| from + i * delta }
    end

    def initialize(x=[],y=[],&block)
      self.x = x
      self.y = y
      yield(self) if block_given?
    end

    def x
      self[:x]
    end

    def y
      self[:y]
    end

    def x=(array)
      self[:x] = array
    end

    def y=(array)
      self[:y] = array
    end

    def truncate(number_of_terms)
      Distribution.new(x, y).truncate!(number_of_terms)
    end

    def truncate!(number_of_terms)
      self.x = x[0...number_of_terms]
      self.y = y[0...number_of_terms]
      return self
    end

    def zip(other)
      raise unless self.x == other.x
      y.zip(other.y)
    end

    def zip_xy
      x.zip(y)
    end

    def residuals(other)
      zip(other).map { |this, that| this - that }
    end

    alias :- :residuals

    def sum_of_squares(other)
      residuals(other).inject(0.0) { |sum, residual| sum + residual**2 }
    end

    def integrate
      x.each_with_index.inject(0.0) do |sum, (point,i)| 
        if x[i] == x[-1]
          return sum
        else
          width    = (x[i + 1] - point).abs
          height_1 = y[i] 
          height_2 = y[i+1]

          base_rectangular_area = width * height_1
          upper_triangular_area = width * ((height_1 - height_2).abs / 2.0)

          area = base_rectangular_area + upper_triangular_area
        end
        
        sum + area
      end
    end

  end

end