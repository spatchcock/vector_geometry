module Geometry

  module Spheroid

    # Ellipsoid - 3D analogue of an ellipse. Has 3 axis: a,b and c
    # Spheroid  - Ellipsoid with two equal semi-diameters (a = b)
    # Sphere    - Ellipsoid with three equal semi-diameters (a = b = c)
    # Geoid     - 

    # class Ellipsoid
      
    #   def initialize(a,b,c)
    #     @a_radius = a
    #     @b_radius = b
    #     @c_radius = c
    #   end

    #   def volume
    #     (4.0/3.0) * (Math::PI * a_radius * b_radius * c_radius)
    #   end

    # end

    class Base

      attr_accessor :polar_radius      # semi-minor axis 
      attr_accessor :equatorial_radius # semi-major axis
      attr_accessor :unit

      # Unit is not functional but is simply memoized so that the basis for any calculations 
      # is clear
      def initialize(equatorial_radius, polar_radius, unit = :km)
        @polar_radius      = polar_radius
        @equatorial_radius = equatorial_radius
        @unit              = unit
      end

      def mean_radius
        # http://en.wikipedia.org/wiki/Earth_radius
        @mean_radius ||= (@polar_radius + 2 * @equatorial_radius) / 3.0
      end

      def flattening
        # http://en.wikipedia.org/wiki/Reference_ellipsoid
        @flattening ||= (@equatorial_radius - @polar_radius) / @equatorial_radius
      end

      def inverse_flattening
        @inverse_flattening ||= 1.0 / flattening
      end

      def flattening_complement_squared
        # http://www.mathworks.co.uk/help/aeroblks/geodetictogeocentriclatitude.html
        @flattening_complement_squared ||= (1.0 - flattening) * (1.0 - flattening)    
      end
   
      def volume
        @volume ||= (4.0 / 3.0) * (Math::PI * @polar_radius * @equatorial_radius ** 2)
      end

      # http://en.wikipedia.org/wiki/Earth_radius
      def radius_at_geodetic_latitude(lat, options = {})
        lat = Geometry.deg_to_rad(lat) unless options[:unit] == :radians

        numerator   = (@equatorial_radius**2 * Math.cos(lat))**2 + (@polar_radius**2 * Math.sin(lat))**2
        denominator = (@equatorial_radius    * Math.cos(lat))**2 + (@polar_radius    * Math.sin(lat))**2

        Math.sqrt(numerator/denominator)
      end

      def geodetic_to_geocentric_latitude(lat, options = {})
        lat = Geometry.deg_to_rad(lat) unless options[:unit] == :radians

        Math.atan(Math.tan(lat) * flattening_complement_squared)  
      end

      # Invoke the haversine formula in the context of the spheroid represented by self
      def haversine_distance(point_1, point_2, options = {})
        Geometry.haversine_distance(point_1, point_2, mean_radius, options)
      end
    
    end

    Mercury = Geometry::Spheroid::Base.new(2439.7, 2439.7)

    Venus   = Geometry::Spheroid::Base.new(6051.8, 6051.8)
    
    Earth   = Geometry::Spheroid::Base.new(6378.1370, 6356.7523)
    
    Moon    = Geometry::Spheroid::Base.new(1738.1, 1736.0)
    
    Mars    = Geometry::Spheroid::Base.new(3396.2, 3376.2)
    
    Jupiter = Geometry::Spheroid::Base.new(71492, 66854)
    
    Saturn  = Geometry::Spheroid::Base.new(60268, 54364)
    
    Uranus  = Geometry::Spheroid::Base.new(25559, 24973)
    
    Neptune = Geometry::Spheroid::Base.new(24764, 24341)
    
    Pluto   = Geometry::Spheroid::Base.new(1195, 1195)

  end

end