require 'math_function'

include Math

describe Distribution do

  it "should be a Distribution" do
  	Distribution.new.should be_a Distribution
  end

  it "should assign x and y lists on initialization" do
  	dist = Distribution.new([1,2,3,4],[5,6,7,8])
  	dist.x.should eql [1,2,3,4]
  	dist.y.should eql [5,6,7,8]
  end

  it "should assign x and y lists after initialization" do
  	dist = Distribution.new
  	dist.x = [1,2,3,4]
  	dist.y = [5,6,7,8]
  	dist.x.should eql [1,2,3,4]
  	dist.y.should eql [5,6,7,8]
  end

  context "residuals" do

    before do
      @dist1 = Distribution.new([1,2,3,4],[5,6,7,8])
      @dist2 = Distribution.new([1,2,3,4],[2,2,2,2])
    end

    it "should return a list of residuals of y using verbose method call" do
      @dist1.residuals(@dist2).should eql [3,4,5,6]
    end

    it "should return a list of residuals of y using operator method call" do
      (@dist1 - @dist2).should eql [3,4,5,6]
    end

    it "should raise error if x values not the same" do
      @dist2.x = [1,2,3]
      lambda{(@dist1 - @dist2)}.should raise_error
    end

  end

  context "#zip" do

    it "should zip y terms of each distribution" do
      dist1 = Distribution.new([1,2,3,4],[5,6,7,8])
      dist2 = Distribution.new([1,2,3,4],[5,6,7,8])
      dist1.zip(dist2).should eql [[5,5],[6,6],[7,7],[8,8]]
    end

  end

  context "sum of squares" do

    it "should return zero for identical distribution" do
      dist1 = Distribution.new([1,2,3,4],[5,6,7,8])
      dist2 = Distribution.new([1,2,3,4],[5,6,7,8])

      dist1.sum_of_squares(dist2).should eql 0.0
    end

    it "should return correct sum of squares" do
      dist1 = Distribution.new([1,2,3,4],[5,6,7,8])
      dist2 = Distribution.new([1,2,3,4])
      
      dist2.y = [4,5,6,7]
      dist1.sum_of_squares(dist2).should eql 4.0

      dist2.y = [6,7,8,9]
      dist1.sum_of_squares(dist2).should eql 4.0

      dist2.y = [2,2,2,2]
      dist1.sum_of_squares(dist2).should eql 9.0+16.0+25.0+36.0
    end

  end

  context "truncate" do

    it "non bang method should return a new distribution" do
      dist = Distribution.new([1,2,3,4,5,6,7,8,9,10],[1,4,7,8,10,12,14,17,18,20])
      trunc = dist.truncate(6)
      trunc.should be_a Distribution
      trunc.should_not be dist
    end

    it "bang method should return modified self" do
      dist = Distribution.new([1,2,3,4,5,6,7,8,9,10],[1,4,7,8,10,12,14,17,18,20])
      trunc = dist.truncate!(6)
      trunc.should be_a Distribution
      trunc.should be dist
    end

    it "non bang method should return new distribution with x and y terms truncated" do
      dist = Distribution.new([1,2,3,4,5,6,7,8,9,10],[1,4,7,8,10,12,14,17,18,20])
      
      truncated_dist = dist.truncate(6)
      truncated_dist.x.should eql [1,2,3,4,5,6]
      truncated_dist.y.should eql [1,4,7,8,10,12]

      truncated_dist = dist.truncate(2)
      truncated_dist.x.should eql [1,2]
      truncated_dist.y.should eql [1,4]

      truncated_dist = dist.truncate(9)
      truncated_dist.x.should eql [1,2,3,4,5,6,7,8,9]
      truncated_dist.y.should eql [1,4,7,8,10,12,14,17,18]
    end

    it "bang method should return modified distribution with x and y terms truncated" do
      dist = Distribution.new([1,2,3,4,5,6,7,8,9,10],[1,4,7,8,10,12,14,17,18,20])
      
      dist.truncate!(6)
      dist.x.should eql [1,2,3,4,5,6]
      dist.y.should eql [1,4,7,8,10,12]

      dist.truncate!(2)
      dist.x.should eql [1,2]
      dist.y.should eql [1,4]

      dist.truncate!(9)
      dist.x.should eql [1,2]
      dist.y.should eql [1,4]
    end
  end

  context "integrate" do

    it "should calculate area under distribution" do
      x,y = [1,2,3,4,5,6,7,8,9,10],[1,4,7,8,10,12,14,17,18,20]
      dist = Distribution.new(x,y)
      dist.integrate.should eql 100.5
    end

    it "should create a histogram with varying widths" do
      x,y = [1,2,4,5,6,7,10,12,14,20],[1,4,7,8,10,12,14,17,18,20]
      dist = Distribution.new(x,y)
      dist.integrate.should eql 260.0
    end
    
  end

  context "class methods" do

    context "generating a scale" do

      it "should generate an array" do
        test_array = [0,2,4,6,8,10,12,14,16,18,20]
        Distribution.scale(0,20,2).should be_a Array
      end

      it "should generate an array from 0 to 20 with a step size of 2" do
        test_array = [0,2,4,6,8,10,12,14,16,18,20]
        Distribution.scale(0,20,2).should eql test_array
      end

      it "should generate an array from 0 to 5 with a step size of 0.5" do
        test_array = [0.0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0]
        Distribution.scale(0,5,0.5).should eql test_array
      end

      it "should generate an array from -10 to 10 with a step size of 2" do
        test_array = [-10,-8,-6,-4,-2,0,2,4,6,8,10]
        Distribution.scale(-10,10,2).should eql test_array
      end

      it "should generate an array from -10 to 10 with a step size of 0.002" do
        test_array = [-10,-8,-6,-4,-2,0,2,4,6,8,10]
        scale = Distribution.scale(-10,10,0.002)
        scale.size.should eql 10001
        scale.first.should eql -10.0
        scale.last.should eql 10.0
      end

    end

  end

end