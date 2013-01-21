require 'p_math'

include PMath

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

end