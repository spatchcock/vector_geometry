module Geometry

  def self.deg_to_rad(deg)
    deg * Math::PI / 180.0
  end

  def self.rad_to_deg(rad)
    (rad * 180.0) / Math::PI 
  end

  def self.haversine_distance(point_1,point_2,radius, options = {})
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

  def self.pythagorean_distance(point_1, point_2)
    x = point_2[0] - point_1[0]
    y = point_2[1] - point_1[1]

    Math.sqrt(x * x + y * y).abs
  end

end