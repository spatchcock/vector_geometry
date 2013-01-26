
module PMath

  class Vector

    def self.from_polar(magnitude, angle, options = {})
      angle = PMath.deg_to_rad(angle) if options[:unit] = :deg

      y = Math.sin(angle) * magnitude
      x = Math.cos(angle) * magnitude
      
      Vector.new(x,y)
    end

    def self.from_spherical(lat,lng,r)
      from_unit_sphere(lat,lng).scale(r)
    end

    def self.from_unit_sphere(lat,lng)
      xy_plane_projection = Math.cos(lat)

      x = Math.cos(lng) * xy_plane_projection
      y = Math.sin(lng) * xy_plane_projection
      z = Math.sin(lat)

      Vector.new(x,y,z)
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

    def orthogonal?(other)
      dot(other) == 0
    end

    def parallel?(other)
      cross(other) == 0
    end

    def inspect
      puts "[#{x}, #{y}, #{z}]"
    end

    def distance_from_line(point_a,point_b)
      # Define the line as the vector between two points
      line_vector  = point_b - point_a
      # Define a second vector representing the distance between self and the line start
      point_vector = self - point_a

      # The magnitude of the cross product is equal to the area of the parallelogram described
      # by the two vectors. Dividing by the line length gives the perpendicular distance.
      (line_vector.cross(point_vector).magnitude / line_vector.magnitude).abs
    end  

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

    protected

  end

end