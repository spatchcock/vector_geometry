require 'p_math/vector'


module PMath

  def self.deg_to_rad(deg)
    deg * 2 * Math::PI / 360.0
  end

  def self.rad_to_deg(rad)
    (rad * 360.0) / (2 * Math::PI) 
  end

  def self.haversine(point_1,point_2,radius, options = {})
    lat_1 = point_1[0]
    lng_1 = point_1[1]
    lat_2 = point_2[0]
    lng_2 = point_2[1]

    if options[:unit] = :deg
      lat_1 = deg_to_rad(lat_1)
      lng_1 = deg_to_rad(lng_1)
      lat_2 = deg_to_rad(lat_2)
      lng_2 = deg_to_rad(lng_2)
    end

    lat_diff = 0.5 * (lat_2 - lat_1);
    lat_diff = Math.sin(lat_diff);
    lat_diff = lat_diff * lat_diff;

    lng_diff = 0.5 * (lng_2 - lng_1);
    lng_diff = Math.sin(lng_diff);
    lng_diff = lng_diff * lng_diff;

    result = lat_diff;
    result += Math.cos(lat_1) * Math.cos(lat_2) * lng_diff;
    result = Math.sqrt(result);

    return radius * 2 * Math.asin(result);
    
  end

  # Ellipsoid - 3D analogue of an ellipse. Has 3 axis: a,b and c
  # Spheroid  - Ellipsoid with two equal semi-diameters (a = b)
  # Sphere    - Ellipsoid with three equal semi-diameters (a = b = c)
  # Geoid     - 

  class Sphere

    attr_accessor :radius

    def initialize(radius)
      @radius = radius
    end

    def diameter
      @radius * 2
    end

    def circumference
      2.0 * Math::PII * radius
    end

    def volume
      (4.0/3.0) * (Math::PI * radius ** 3)
    end

    def surface_area
      4.0 * (Math::PI * radius ** 2)
    end

  end

  class Spheroid

    attr_accessor :polar_radius      # semi-minor axis 
    attr_accessor :equatorial_radius # semi-major axis

    def initialize(equatorial_radius, polar_radius)
      @polar_radius      = polar_radius
      @equatorial_radius = equatorial_radius
    end

    def radius
      mean_radius
    end

    def mean_radius
      (polar_radius + equatorial_radius) / 2.0
    end

    def volume
      (4.0/3.0) * (Math::PI * polar_radius * equatorial_radius ** 2)
    end

    # http://en.wikipedia.org/wiki/Earth_radius#Radius+at+a+given+geodetic+latitude
    def geodetic_radius(lat)
      numerator   = (equatorial_radius**2 * Math.cos(lat))**2 + (polar_radius**2 * Math.sin(lat))**2
      denominator = (equatorial_radius    * Math.cos(lat))**2 + (polar_radius    * Math.sin(lat))**2

      Math.sqrt(numerator/denominator)
    end

    # http://en.wikipedia.org/wiki/Reference_ellipsoid
    def flattening
      (equatorial_radius - polar_radius) / equatorial_radius
    end
  
  end

  class Ellipsoid
    
    def initialize(a,b,c)
      @a_radius = a
      @b_radius = b
      @c_radius = c
    end

    def volume
      (4.0/3.0) * (Math::PI * a_radius * b_radius * c_radius)
    end

  end

  class Earth < Spheroid

    MEAN_RADIUS       = 6371.009  # km
    POLAR_RADIUS      = 6356.7523 # km
    EQUATORIAL_RADIUS = 6378.1370 # km

    attr_reader :radius            # mean
    attr_reader :polar_radius      # semi-minor axis 
    attr_reader :equatorial_radius # semi-major axis

    def initialize
      @radius            = Earth::MEAN_RADIUS
      @polar_radius      = Earth::POLAR_RADIUS
      @equatorial_radius = Earth::EQUATORIAL_RADIUS
    end

  end

end