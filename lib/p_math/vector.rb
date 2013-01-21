
module PMath

  def self.deg_to_rad(deg)
    deg * 2 * Math::PI / 360.0
  end

  class Vector

    def self.from_polar(magnitude, angle, options = {})

      angle = PMath.deg_to_rad(angle) if options[:unit] = :deg

      y = Math.sin(angle) * magnitude
      x = Math.cos(angle) * magnitude
      
      Vector.new(x,y)
    end


    attr_accessor :x, :y, :z

    def initialize(x, y, z = 0)
      @x = x.to_f
      @y = y.to_f
      @z = z.to_f
    end

    def add(other)      
      Vector.new(x + other.x, y + other.y, z + other.z)
    end
    alias :+ :add


    def subtract(other)
      Vector.new(x - other.x, y - other.y, z - other.z)
    end
    alias :- :subtract


    def multiply(n)
      Vector.new(x * n, y * n, z * n)
    end
    alias :* :multiply


    def divide(n)      
      Vector.new(x / n, y / n, z / n)
    end
    alias :/ :divide

    def magnitude
      # Do we need to be able to calculate the magnitude of just two components? 
      # For example, calculating the heading with respect to the z component requires
      # the magnitude of the x-y component

      Math.sqrt(x**2 + y**2 + z**2)
    end
    alias :r :magnitude

    def normalize
      divide(magnitude)
    end

    # in radians
    def latitude
      Math.atan2(z,x)
    end

    # in radians
    def longitude      
      Math.atan2(y,x)      
    end
    alias :heading :longitude

    def dot(other)      
      return (x * other.x) + (y * other.y) + (z * other.z)
    end

    def angle_between(other)
      Math.acos(dot(other) / (r * other.r))
    end

    def cross(other)
      new_x = (y * other.z) - (z * other.y)
      new_y = (z * other.x) - (x * other.z)
      new_z = (x * other.y) - (y * other.x)

      Vector.new(new_x, new_y, new_z)
    end

    def cross_length(other)
      cross(other).magnitude
    end

    def cross_normal(other)
      cross(other).normalize
    end

    def othogonal?(other)
      dot(other) == 0
    end

    def parallel?(other)
      cross(other) == 0
    end

    def distance_from_line(point_a,point_b)
      line_vector_a_b = point_b - point_a
      line_vector_O_a = point_a - self

      parallelogram_area = line_vector_O_a.c
    end

    def rotate

    end

  end

end