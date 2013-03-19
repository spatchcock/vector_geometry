module Geometry

  class GeoVector < Vector

    @@spheroid = nil

    def self.from_great_circle_intersection(vector_1,vector_2,vector_3,vector_4)
      normal_to_great_circle_1 = vector_1.cross_normal(vector_2)
      normal_to_great_circle_2 = vector_3.cross_normal(vector_4)

      unit_vector = normal_to_great_circle_1.cross_normal(normal_to_great_circle_2)

      if @@spheroid
        unit_vector.scale(@@spheroid.mean_radius)
      else
        unit_vector
      end
    end

    # Return a 3-dimensional cartesian vector representing the given latitude and longitude.
    def self.from_geographic(lat, lng, options = {})

      spheroid = @@spheroid || options[:spheroid]
      
      unless options[:unit] == :radians
        lat = Geometry.deg_to_rad(lat)
        lng = Geometry.deg_to_rad(lng)
      end

      # Convert the geodetic latitude to geocentric if required
      geocentric_latitude = options[:geocentric] ? lat : spheroid.geodetic_to_geocentric_latitude(lat, :unit => :radians)
      
      # Find the projection of the point on the equatorial plane.
      equatorial_plane_projection = Math.cos(geocentric_latitude)

      x = Math.cos(lng) * equatorial_plane_projection
      y = Math.sin(lng) * equatorial_plane_projection
      z = Math.sin(geocentric_latitude)

      unit_vector = self.new(x,y,z)

      if options[:unit_vector]
        unit_vector
      else
        raise ArgumentError, "No spheroid defined" unless spheroid

        geodetic_radius = spheroid.radius_at_geodetic_latitude(lat, :unit => :radians)
        unit_vector.scale(geodetic_radius)
      end
    end

    attr_accessor :geodetic_radius
    attr_accessor :latitude
    attr_accessor :longitude

    def latitude(options = {})
      @latitude ||= begin
        lat = Math.atan2(@z,@x)

        lat = Math::PI - lat if lat > Math::PI/2.0
        lat = lat.abs        if lat == -0.0

        lat
      end

      options[:unit] == :radians ? @latitude : Geometry.rad_to_deg(@latitude)
    end

    def longitude(options = {})
      @longitude ||= Math.atan2(@y,@x)

      options[:unit] == :deg ? Geometry.rad_to_deg(@longitude) : @longitude
    end

    def geodetic_radius(spheroid = @@spheroid)
      @geodetic_radius ||= spheroid.radius_at_geodetic_latitude(latitude)
    end

    def antipode
      scale(-1.0)
    end

    def mean_geodetic_radius(other)
      (self.geodetic_radius + other.geodetic_radius) / 2.0
    end

    def great_circle_distance(other, options = {})
      
      angular_distance = angle(other) 

      if @@spheroid && !options[:unit_vector]
        if options[:use_mean_geodetic_radius]
          return angular_distance * mean_geodetic_radius(other) 
        else
          return angular_distance * @@spheroid.mean_radius
        end
      else
        angular_distance
      end
    end

    # Calculate the distance of self from a great circle defined by two points.
    def great_circle_distance_from_great_circle(point_a,point_b)

      # The shortest distance from a great circle is the perpendicular distance. 

      # Find the vector which is normal to the plane described by the (curved) line together
      # with the origin.

      normal_to_line = point_a.cross_normal(point_b).scale(@@spheroid.mean_radius)

      # The line between self and the normal vector is perpendicular to the line.
      #
      # Next, find the intersection between the two lines which represents the shortest distance
      # from self to the line.

      intersection = GeoVector.from_great_circle_intersection(point_a, point_b, self, normal_to_line)

      # There are actually two valid intersections (which are antipodes of one another) and we have
      # found one. 
      #
      # Return the smallest distance from self to either intersection

      [self.great_circle_distance(intersection), self.great_circle_distance(intersection.antipode)].min      
    end

    # Calculate the distance of self from a finite line segment defined by two points
    def great_circle_distance_from_arc(point_a,point_b, options = {})

      # Distance from a line segment is similar to the distance from the infinte line (above)
      # with a modification.
      #
      # The distance from an infinitely long line calculates the shortest distance to an infintitely
      # long line. This is the perpendicular distance. In the case of the line segment, this perpendicular
      # may or may not fall on the line segment part of the more general infinte line.
      # 
      # If it does, we can keep the perpendicular distance. If not, the shortest distance will be
      # to either of the two line segments end. Determine which.

      normal_to_line = point_a.cross_normal(point_b).scale(@@spheroid.mean_radius)
      intersection   = GeoVector.from_great_circle_intersection(point_a, point_b, self, normal_to_line)

      # The point which intersects the two great circles is actually one of two such unique points. We
      # know both fall on the great circle described by the points but we need to establish whether either
      # fall on our line segment, i.e. between them. If so, we can take the perpendicular distance from 
      # the intersection point.

      line_length = point_a.great_circle_distance(point_b, options)

      if line_length >= intersection.great_circle_distance(point_a, options) && 
         line_length >= intersection.great_circle_distance(point_b, options)

        # The intersection falls on the line segment.
        # Calculate the perpendicular distance.
        
        return self.great_circle_distance(intersection, options)

      elsif line_length >= intersection.antipode.great_circle_distance(point_a, options) && 
            line_length >= intersection.antipode.great_circle_distance(point_b, options)

        # The *other* intersection falls on the line segment.
        # Calculate the perpendicular distance.

        return self.great_circle_distance(intersection.antipode, options)

      else

        # Neither intersection falls on the line segment.
        # Calculate the distance to the closer of the line segment ends.

        return [ self.great_circle_distance(point_a, options), self.great_circle_distance(point_b, options) ].min
      end
    end

    # Supports a polyline based on either cartesian or angular coordinates. Specify which using the :basis
    # option
    #
    #  :cartesian => cartesian coordinates (x,y)
    #
    # otherwise lat/lng pairs are assumed
    #
    def great_circle_distance_from_polyline(polyline, options = {})

      constructor = Proc.new do |vertex|
        if options[:basis] == :cartesian
          self.class.new(vertex[0], vertex[1], vertex[2])
        else
          self.class.from_geographic(vertex[0], vertex[1], options)          
        end
      end
      
      # memoize the last processed point as both array and vector objects
      last_array  = polyline.first
      last_vector = constructor.call(last_array)

      minimum_distance = 999999999999

      for vertex in polyline[1..-1]  

        next if vertex == last_array  

        start_vector = last_vector
        end_vector   = constructor.call(vertex)

        this_segment_distance = great_circle_distance_from_arc(start_vector, end_vector, options)

        if(this_segment_distance < minimum_distance)
          minimum_distance = this_segment_distance
        end

        last_array  = vertex
        last_vector = end_vector
      end

      return minimum_distance
    end

    # Convert self to a geographic lat/lng pair. 
    def to_geographic(options = {})
      [latitude(options), longitude(options)]
    end

    protected
      
    # Return true of point is closer to both points than the points are to each other
    def within_both_radii?(point_a,point_b)
      line_length = point_a.great_circle_distance(point_b)
      self.great_circle_distance(point_a) < line_length && self.great_circle_distance(point_b) < line_length
    end


  end

  class EarthVector < GeoVector
    @@spheroid = Geometry::Spheroid::Earth
  end

end

