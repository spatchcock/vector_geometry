module Geometry

  module Spheroid

    class Sphere < Spheroid::Base

      def initialize(radius, unit = :km)
        super(radius,radius,unit)
      end

      def radius
        @equatorial_radius
      end

      def diameter
        @diameter ||= radius * 2.0
      end

      def circumference
        @circumference ||= 2.0 * Math::PI * radius
      end

      def surface_area
        @surface_area ||= 4.0 * (Math::PI * radius ** 2)
      end

    end
  end
end