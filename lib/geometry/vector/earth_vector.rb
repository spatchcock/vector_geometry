module Geometry

  class EarthVector < GeoVector
    @@spheroid = Geometry::Spheroid::Earth
  end

end