require 'spec_helper'
# require 'geometry'

include Geometry

describe Vector do

	context "30 degrees and magnitude 2" do

    before do
    	@angle     = 30 # degrees
    	@magnitude = 2

    	@vector = Vector.from_polar(@magnitude, @angle, :unit => :deg)
    end

    it "should calculate the x component" do

      @vector.x.should be_within(0.00001).of(Math.sqrt(3))
    end


    it "should calculate the y component" do

      @vector.y.should be_within(0.00001).of(1)
    end

  end

  context "39 degrees and magnitude 55" do

    before do
    	@angle     = 39 # degrees
    	@magnitude = 55

    	@vector = Vector.from_polar(@magnitude, @angle, :unit => :deg)
    end

    it "should calculate the x component" do

      @vector.x.should be_within(0.01).of(42.74)
    end


    it "should calculate the y component" do

      @vector.y.should be_within(0.01).of(34.61)
    end

  end

  context "44 degrees and magnitude 28" do

    before do
    	@angle     = 28 # degrees
    	@magnitude = 44

    	@vector = Vector.from_polar(@magnitude, @angle, :unit => :deg)
    end

    it "should calculate the x component" do

      @vector.x.should be_within(0.01).of(38.84)
    end


    it "should calculate the y component" do

      @vector.y.should be_within(0.01).of(20.65)
    end

  end

  context "2,2 plus 2,1" do


    it "should calculate the resultant vector" do

      vector_1 = Vector.new(2,2)
      vector_2 = Vector.new(2,1)

      resultant = vector_1 + vector_2

      resultant.x.should eql 4.0
      resultant.y.should eql 3.0
      resultant.magnitude.should eql 5.0
    end

  end

  context "40,0 plus 0,50" do


    it "should calculate the resultant vector" do

      vector_1 = Vector.new(40,0)
      vector_2 = Vector.new(0,50)

      resultant = vector_1 + vector_2

      resultant.x.should eql 40.0
      resultant.y.should eql 50.0
      resultant.magnitude.should be_within(0.1).of(64.0)
    end

  end

  context "4,2 plus 2,5" do


    it "should calculate the resultant vector" do

      vector_1 = Vector.new(4,2)
      vector_2 = Vector.new(2,5)

      resultant = vector_1 + vector_2

      resultant.x.should eql 6.0
      resultant.y.should eql 7.0
      resultant.magnitude.should be_within(0.02).of(9.2)
    end

  end

  context "2,3,4 and 5,6,7" do

    it "should calucate the cross product" do
      vector_1 = Vector.new(2,3,4)
      vector_2 = Vector.new(5,6,7)

      resultant = vector_1.cross(vector_2)

      resultant.x.should eql -3.0
      resultant.y.should eql  6.0
      resultant.z.should eql -3.0
    end

  end

  context "great circle" do

    before do
      @point_1 = [51.454007, -0.263672]
      @point_2 = [55.862982, -4.251709]
    end

    it "should calculate a great circle distance using the haversine formula" do
      hv_distance = Geometry.haversine_distance(@point_1,@point_2,Geometry::Spheroid::Earth.mean_radius,:unit => :deg)
      
      hv_distance.should be_within(0.0001).of(556.0280983558)
    end

    it "should calculate a great circle distance using the angle between two cartesian vectors" do
      vector_1 = EarthVector.from_geographic(@point_1[0],@point_1[1])
      vector_2 = EarthVector.from_geographic(@point_2[0],@point_2[1])

      angle      = vector_1.angle(vector_2)
      vec_distance = angle * Geometry::Spheroid::Earth.mean_radius
      
      vec_distance.should be_within(0.0000001).of(557.4229505894594)
    end

    it "should calculate distance between point using Pythagoras' theorum" do

      # Scale longitude change according to latitude
      # Perhaps taking the mean latitude between the two points would be an improvement
      deg_ew = (@point_2[1] - @point_1[1]) * Math.cos(@point_1[0])
      deg_ns = (@point_1[0] - @point_2[0])
      
      # Calculate angle change using Pythagoras
      deg_change = Math.sqrt(deg_ew ** 2 + deg_ns ** 2)

      # Convert to radians and calculate distance
      py_distance = Geometry.deg_to_rad(deg_change) * Geometry::Spheroid::Earth.mean_radius

      py_distance.should be_within(0.000001).of(517.4118204446571)
    end

    it "haversine and geocentric vector approaches should be equal" do
      # Haversine
      hv_distance = Geometry.haversine_distance(@point_1,@point_2,Geometry::Spheroid::Earth.mean_radius,:unit => :deg)

      # Vector
      vector_1 = EarthVector.from_geographic(@point_1[0],@point_1[1], :geocentric => true)
      vector_2 = EarthVector.from_geographic(@point_2[0],@point_2[1], :geocentric => true)
      vec_distance = vector_1.angle(vector_2) * Geometry::Spheroid::Earth.mean_radius

      hv_distance.should be_within(0.0000001).of(vec_distance)
    end

    it "Pythagoras should underestimate great circle" do
      # Since the pythagoras approach assumes a flat surface

      # Haversine
      hv_distance = Geometry.haversine_distance(@point_1,@point_2,Geometry::Spheroid::Earth.mean_radius,:unit => :deg)

      # Pythagoras
      deg_ew = (@point_2[1] - @point_1[1]) * Math.cos(@point_1[0])
      deg_ns = (@point_1[0] - @point_2[0])
      deg_change  = Math.sqrt(deg_ew ** 2 + deg_ns ** 2)
      py_distance = Geometry.deg_to_rad(deg_change) * Geometry::Spheroid::Earth.mean_radius
      
      py_distance.should be < hv_distance
    end

  end

  it "should convert degrees to radians" 

end
