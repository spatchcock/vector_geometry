require 'spec_helper'

describe Geometry::GeoVector do 

  it "should calculate the great circle intersection" do
    point_1 = Geometry::GeoVector.from_geographic(  0.0,  0.0)
		point_2 = Geometry::GeoVector.from_geographic(  0.0, 10.0)
		point_3 = Geometry::GeoVector.from_geographic( 20.0, 10.0)
		point_4 = Geometry::GeoVector.from_geographic(-20.0, 10.0)

		intersection = Geometry::GeoVector.from_great_circle_intersection(point_1,point_2,point_3,point_4)

		intersection.should be_a Geometry::GeoVector
		
		coords = intersection.to_geographic(:unit=>:deg)

		coords.first.should be_within(0.001).of(0.0)
		coords.last.should be_within(0.001).of(-170.0)

		antipode_coords = intersection.antipode.to_geographic(:unit=>:deg)

		antipode_coords.first.should be_within(0.001).of(0.0)
		antipode_coords.last.should be_within(0.001).of(10.0)
  end

  it "should calculate a great circle distance" do
  	point_1 = Geometry::EarthVector.from_geographic(0.0,  0.0)
		point_2 = Geometry::EarthVector.from_geographic(0.0, 10.0)

		geo_vector_estimate = point_1.great_circle_distance(point_2)

		haversine_estimate = Geometry.haversine_distance([0.0,  0.0], [0.0,  10.0], Geometry::Spheroid::Earth.mean_radius, :unit => :deg)

		haversine_estimate.should be_within(0.001).of(geo_vector_estimate)

  end
	
end