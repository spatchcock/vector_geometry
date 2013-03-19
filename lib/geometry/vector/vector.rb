
module Geometry

  class Vector

    # Return an x/y vector based on a magnitude and a heading.
    def self.from_polar(magnitude, angle, options = {})
      angle = Geometry.deg_to_rad(angle) if options[:unit] = :deg

      y = Math.sin(angle) * magnitude
      x = Math.cos(angle) * magnitude
      
      self.new(x,y)
    end

    attr_accessor :x, :y, :z

    def initialize(x, y, z = 0)
      @x = x.to_f
      @y = y.to_f
      @z = z.to_f
    end

    def add(other)      
      self.class.new(@x + other.x, @y + other.y, @z + other.z)
    end
    alias :+ :add

    def subtract(other)
      self.class.new(@x - other.x, @y - other.y, @z - other.z)
    end
    alias :- :subtract

    def multiply(n)
      scale(n.to_f)
    end
    alias :* :multiply

    def divide(n)      
      scale(1.0/n.to_f)
    end
    alias :/ :divide

    # Return the magnitude of self.
    def magnitude
      Math.sqrt(@x ** 2 + @y ** 2 + @z ** 2)
    end
    alias :r :magnitude

    def scale(scalar)
      self.class.new(@x * scalar, @y * scalar, @z * scalar)
    end

    # Normalize self, that is, return the unit vector with the same direction as self.
    def normalize
      divide(magnitude)
    end

    def heading
      Math.atan2(@y,@x)
    end

    # Return the dot product of self and the passed in vector.
    def dot(other)      
      return (@x * other.x) + (@y * other.y) + (@z * other.z)
    end
    alias :scalar_product :dot

    # Return the cross product of self and the passed in vector.
    def cross(other)
      new_x = (@y * other.z) - (@z * other.y)
      new_y = (@z * other.x) - (@x * other.z)
      new_z = (@x * other.y) - (@y * other.x)

      self.class.new(new_x, new_y, new_z)
    end
    alias :vector_product :cross

    
    # Return the magnitude of the cross product of self and the passed in vector.
    def cross_length(other)
      # cross(other).magnitude

      # It is more efficient to not create a new Vector object since we are only returning 
      # a scalar value 
      new_x = (@y * other.z) - (@z * other.y)
      new_y = (@z * other.x) - (@x * other.z)
      new_z = (@x * other.y) - (@y * other.x)

      Math.sqrt(new_x ** 2 + new_y ** 2 + new_z ** 2)
    end

    # Return the unit vector of the cross product of self and the passed in vector.
    def cross_normal(other)
      cross(other).normalize
    end

    # Return the angle (in radians) between self and the passed in vector.
    def angle(other)

      # Two options here:
      #
      # 1.  Math.atan2(other.cross_length(self), dot(other)) 
      #
      #     This is stable but slower (x 1.5)
      #
      # 2.  Math.acos(dot(other) / (r * other.r)) 
      #
      #     This is faster but unstable around 0 and pi where the gradient of acos approaches 
      #     infinity. An alternative way to view this is that the gradient of cos approaches
      #     zero and small differences in angle can be indistinguishable at some number of 
      #     decimal places.
      #
      
      # Math.acos(dot(other) / (r * other.r)) 
      Math.atan2(other.cross_length(self), dot(other)) 
    end

    # Return the cartesian distance between self and the passed vector
    def distance(other)
      (other - self).magnitude.abs
    end

    # Returns true of the passed in vector is perpendicular to self.
    def orthogonal?(other)
      dot(other) == 0
    end

    # Returns true if the passed in vector is parallel to self.
    def parallel?(other)
      cross(other) == 0
    end

    def ==(other)
      @x == other.x && @y == other.y && @z == other.z
    end

    # Calculate the distance of self from the infinite line passing through the two passed in points.
    def distance_from_line(point_a,point_b)
      
      # Define the line as the vector between two points
      line_vector  = point_b - point_a

      # Define a second vector representing the distance between self and the line start
      point_vector = self - point_a

      # The magnitude of the cross product is equal to the area of the parallelogram described
      # by the two vectors. Dividing by the line length gives the perpendicular distance.
      (line_vector.cross(point_vector).magnitude / line_vector.magnitude).abs
    end  

    # Calculate the distance of self from the line segment starting and ending with the two passed in points.
    def distance_from_line_segment(point_a,point_b)

      # Define the line as the vector between two points
      line_vector  = point_b - point_a
      
      # Define a second vector representing the distance between self and the line start
      point_vector = self - point_a

      # Determine if self falls within the perpendicular 'shadow' of the line by calculating
      # the projection of the point vector onto the line.
      #
      # The dot product divided by the magnitude of the line gives the absolute projection
      # of the point vector onto the line.
      #
      # Dividing again by the line magnitude gives the relative projection along the line, 
      # i.e. the ratio of the projection to the line. Values between 0-1 indicate that the
      # point falls within the perpendicular shadow.
      #
      projection_ratio = line_vector.dot(point_vector) / line_vector.magnitude ** 2

      if projection_ratio >= 1
        # The point is beyond point b, calculate distance to point b
        distance = (point_b - self).magnitude
      elsif projection_ratio <= 0
        # The point is beyond point a, calculate distance to point a
        distance = (point_a - self).magnitude
      else
        # The point is in the shadow of the line, return the perpendicular distance
        distance = line_vector.cross(point_vector).magnitude / line_vector.magnitude
      end

      return distance.abs
    end

    def distance_from_polyline(polyline)
      
      # memoize the last processed point as both array and vector objects
      last_array  = polyline.first
      last_vector = self.class.new(last_array[0], last_array[1])

      minimum_distance = 999999999999

      polyline[1..-1].each do |vertex|  

        next if vertex == last_array  

        start_vector = last_vector
        end_vector   = self.class.new(vertex[0],vertex[1])

        this_segment_distance = distance_from_line_segment(start_vector, end_vector)

        if(this_segment_distance < minimum_distance)
          minimum_distance = this_segment_distance
        end

        last_array  = vertex
        last_vector = end_vector
      end

      return minimum_distance
    end

    def inspect
      puts "[#{@x}, #{@y}, #{@z}]"
    end

    protected

  end

end