require 'spec_helper'

include Geometry

describe Vector do

  context "initialization" do

    it ".new constructor should initialize Vector object" do
      vector = Vector.new(4,5)
      vector.should be_a Geometry::Vector
    end

  end

  context "instance variables" do

    it "should have x and y values" do
      vector = Vector.new(4,5)

      vector.x.should eql 4.0
      vector.y.should eql 5.0
    end

    it "should not have a z values" do
      vector = Vector.new(4,5)

      vector.z.should eql 0.0
    end

    it "should have x, y and z values" do
      vector = Vector.new(4,5,2)

      vector.x.should eql 4.0
      vector.y.should eql 5.0
      vector.z.should eql 2.0
    end
    
  end

  context "adding" do
 
    it "should add two 2D vectors" do
      vector_1 = Vector.new(2,2)
      vector_2 = Vector.new(2,3)

      vector_3 = vector_1 + vector_2

      vector_3.x.should eql 4.0
      vector_3.y.should eql 5.0
    end

    it "should add two 3D vectors" do
      vector_1 = Vector.new(2,2,1)
      vector_2 = Vector.new(2,3,10)

      vector_3 = vector_1 + vector_2

      vector_3.x.should eql 4.0
      vector_3.y.should eql 5.0
      vector_3.z.should eql 11.0
    end

  end

  context "subtracting" do
 
    it "should subtract two 2D vectors" do
      vector_1 = Vector.new(2,2)
      vector_2 = Vector.new(2,3)

      vector_3 = vector_1 - vector_2

      vector_3.x.should eql 0.0
      vector_3.y.should eql -1.0
    end

    it "should subtract two 3D vectors" do
      vector_1 = Vector.new(2,2,1)
      vector_2 = Vector.new(2,3,10)

      vector_3 = vector_1 - vector_2
      vector_3.x.should eql 0.0
      vector_3.y.should eql -1.0
      vector_3.z.should eql -9.0
    end

  end

  context "multiplying" do
 
    it "should multiply a 2D vector by a scalar" do
      vector_1 = Vector.new(2,2)

      vector_2 = vector_1 * 4
      vector_2.x.should eql 8.0
      vector_2.y.should eql 8.0
    end

    it "should multiply a 3D vector by a scalar" do
      vector_1 = Vector.new(2,2,10)

      vector_2 = vector_1 * 4
      vector_2.x.should eql 8.0
      vector_2.y.should eql 8.0
      vector_2.z.should eql 40.0
    end

  end

  context "dividing" do
 
    it "should divide a 2D vector by a scalar" do
      vector_1 = Vector.new(2,2)

      vector_2 = vector_1 / 4
      vector_2.x.should eql 0.5
      vector_2.y.should eql 0.5
    end

    it "should divide a 3D vector by a scalar" do
      vector_1 = Vector.new(2,2,10)

      vector_2 = vector_1 / 4
      vector_2.x.should eql 0.5
      vector_2.y.should eql 0.5
      vector_2.z.should eql 2.5
    end

  end

  context "magnitude" do
 
    it "should calculate the magnitude of a 2D vector" do
      vector = Vector.new(3,4)

      vector.r.should be_within(0.1).of(5)
    end

    it "should calculate the magnitude of a 3D vector" do
      vector = Vector.new(3,4,5)

      vector.r.should be_within(0.1).of(7.0)
    end

  end

  context "normalize" do

    it "should normalize a 2D vector" do
      vector = Vector.new(3,4)

      unit_vector = vector.normalize

      unit_vector.x.should be_within(0.01).of(0.6)
      unit_vector.y.should be_within(0.01).of(0.8)

      unit_vector.r.round(1).should eql 1.0
    end

    it "should normalize a 3D vector" do
      vector = Vector.new(3,4,5)

      unit_vector = vector.normalize

      unit_vector.x.should be_within(0.05).of(0.42)
      unit_vector.y.should be_within(0.05).of(0.56)
      unit_vector.z.should be_within(0.05).of(0.70)

      unit_vector.r.round(1).should eql 1.0
    end

  end

  context "heading" do

    it "should calculate heading of a 2D vector" do
      vector = Vector.new(3,4)

      vector.heading.should be_within(0.1).of(0.9)
    end

  end

  context "dot product" do

    it "should return the dot product of 2D vector" do
      vector_1 = Vector.new(5,0)
      vector_2 = Vector.new(5,5)

      dot = vector_1.dot(vector_2)

      dot.should eql 25.0

      # Compare two ways of calculating dot product
      dot.should be_within(0.0001).of(vector_1.r * vector_2.r * Math.cos(vector_1.angle(vector_2)))
    end

    it "should return the dot product of 3D vector" do
      vector_1 = Vector.new(5,0,8)
      vector_2 = Vector.new(5,5,3)

      dot = vector_1.dot(vector_2)

      dot.should eql 49.0

      # Compare two ways of calculating dot product
      dot.should be_within(0.1).of(vector_1.r * vector_2.r * Math.cos(vector_1.angle(vector_2)))
    end

  end

  context "distance from line" do

    before do
      @line_start = Vector.new(0,0)
      @line_end   = Vector.new(5,5)
    end

    it "should calculate a distance within shadow of line" do
      point = Vector.new(5,0)
      point.distance_from_line(@line_start,@line_end).should be_within(0.1).of(3.5)

      point = Vector.new(0,1)
      point.distance_from_line(@line_start,@line_end).should be_within(0.1).of(0.707)

    end

    it "should calculate a distance if beyond end point" do
      point = Vector.new(6,5)

      point.distance_from_line(@line_start,@line_end).should be_within(0.001).of(0.707106)
    end

    it "should calculate a distance if beyond start point" do
      point = Vector.new(-1,1)

      point.distance_from_line(@line_start,@line_end).should be_within(0.001).of(1.4142)
    end

  end

  context "distance from line segment" do

    before do
      @line_start = Vector.new(0,0)
      @line_end   = Vector.new(5,5)
    end

    it "should calculate a distance within shadow of line" do
      point = Vector.new(5,0)
      point.distance_from_line_segment(@line_start,@line_end).should be_within(0.1).of(3.5)

      point = Vector.new(0,1)
      point.distance_from_line_segment(@line_start,@line_end).should be_within(0.1).of(0.707)

    end

    it "should calculate a distance if beyond end point" do
      point = Vector.new(6,5)

      point.distance_from_line_segment(@line_start,@line_end).should be_within(0.001).of(1.0)
    end

    it "should calculate a distance if beyond start point" do
      point = Vector.new(-1,1)

      point.distance_from_line_segment(@line_start,@line_end).should be_within(0.001).of(1.4142)
    end

  end

end

