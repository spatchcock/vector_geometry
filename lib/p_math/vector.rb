
module PMath

  def self.deg_to_rad(deg)
    deg * 2 * Math::PI / 360.0
  end

  def self.rad_to_deg(rad)
    (rad * 360.0) / (2 * Math::PI) 
  end

  class Vector

    EARTH_MEAN_RADIUS_KMS       = 6371.009
    EARTH_POLAR_RADIUS_KMS      = 6356.7523
    EARTH_EQUATORIAL_RADIUS_KMS = 6378.1370

    def self.from_polar(magnitude, angle, options = {})

      angle = PMath.deg_to_rad(angle) if options[:unit] = :deg

      y = Math.sin(angle) * magnitude
      x = Math.cos(angle) * magnitude
      
      Vector.new(x,y)
    end

    def self.from_spherical(lat,lng, r = EARTH_RADIUS_KMS)
      # use lat to get accurate r
      # e.g. 
      from_unit_sphere(lat,lng).scale(r)
    end

    def self.from_unit_sphere(lat,lng)
      projection = Math.cos(lat)

      x = Math.cos(lng) * projection
      y = Math.sin(lng) * projection
      z = Math.sin(lat)

      Vector.new(x,y,z)
    end

    # http://en.wikipedia.org/wiki/Earth_radius#Radius+at+a+given+geodetic+latitude
    def self.geodetic_radius(lat)
      numerator   = (EARTH_EQUATORIAL_RADIUS_KMS**2 * Math.cos(lat))**2 + (EARTH_POLAR_RADIUS_KMS**2 * Math.sin(lat))**2
      denominator = (EARTH_EQUATORIAL_RADIUS_KMS    * Math.cos(lat))**2 + (EARTH_POLAR_RADIUS_KMS    * Math.sin(lat))**2

      Math.sqrt(numerator/denominator)
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
      puts "#{x}, #{y}, #{z||'-'}"
    end

    def distance_from_line(point_a,point_b)
      line_vector  = point_b - point_a
      point_vector = self    - point_a

      projection_ratio = line_vector.dot(point_vector) / line_vector.r ** 2

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

  end

end