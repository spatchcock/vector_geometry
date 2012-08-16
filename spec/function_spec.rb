require 'math/function'

include Math

describe Function do

  describe "initialization" do
 
    it ".new constructor should initialize Function object" do
      model = Function.new { a*x + b*x**2 }
      model.should be_a Function
    end

    it "Math module constructor should initialize Function object" do
      model = Math.function { a*x + b*x**2 }
      model.should be_a Function
    end

  end

  describe "instance variables" do

    it "basic polynomial should have instance variables representing all variables and parameters" do
      model = Math.function { a*x + b*x**2 }
      [:@a,:@b,:@x].each { |var| model.instance_variables.should include var }
    end

    it "exponential function should have instance variables representing all variables and parameters" do
      model = Function.new { a * Math.exp(-b * x) }
      [:@a,:@b,:@x].each { |var| model.instance_variables.should include var }
    end

    it "trigonometric function should have instance variables representing all variables and parameters" do
      model = Math.function { a * Math.sin(b * t) }
      [:@a,:@b,:@t].each { |var| model.instance_variables.should include var }
    end

  end

  describe "singleton methods" do

    describe "basic polynomial" do
  
      it "should have singleton methods for setting all variables and parameters" do
        model = Function.new { a*x + b*x**2 }
        [:a=,:b=,:x=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Math.function { a*x + b*x**2 }
        [:a,:b,:x].each { |var| model.singleton_methods.should include var }
      end

    end

    describe "exponential function" do

      it "should have singleton methods for setting all variables and parameters" do
        model = Math.function { a * Math.exp(-b * x) }
        [:a=,:b=,:x=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Function.new { a * Math.exp(-b * x) }
        [:a,:b,:x].each { |var| model.singleton_methods.should include var }
      end

    end

    describe "trigonometric function" do

      it "should have singleton methods for setting all variables and parameters" do
        model = Function.new { a * Math.sin(b * t) }
        [:a=,:b=,:t=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Math.function { a * Math.sin(b * t) }
        [:a,:b,:t].each { |var| model.singleton_methods.should include var }
      end

    end

  end

  describe "#evaluate" do
    
    it "should return the correct value for basic linear function" do
      model   = Function.new { a * x }
      model.a = 2
      result  = model.evaluate(:x => 5).should eql 10
    end

    it "should return the correct value for polynomial function" do
      model   = Math.function { a * x + b * x**2 }
      model.a = 2
      model.b = 5
      result  = model.evaluate(:x => 5).should eql 135
    end

    it "should return the correct value for exponential function" do
      model   = Function.new { a * Math.exp(b * x) }
      model.a = 2
      model.b = 1
      result  = model.evaluate(:x => 0).should eql 2.0
      result  = model.evaluate(:x => 5).should be_within(0.00000001).of(296.826318205)
    end

    it "should return the correct value for trignometric function" do
      model   = Math.function { a * Math.sin(t) }
      model.a = 2
      result  = model.evaluate(:t => 0).should eql 0.0
      result  = model.evaluate(:t => Math::PI / 2.0).should eql 2.0 
      result  = model.evaluate(:t => Math::PI).should be_within(0.00000001).of(0.0)
      result  = model.evaluate(:t => 3 * Math::PI / 2.0).should eql -2.0 
      result  = model.evaluate(:t => 2 * Math::PI).should be_within(0.00000001).of(0.0)
    end

  end

  describe "#distribution" do

    it "should return an array if Array range given" do
      model = Function.new { a * x }
      model.distribution(:x,[0,1,2,3,4,5]).should be_a Array
    end

    it "should return an array if Range range given" do
      model = Function.new { a * x }
      model.distribution(:x, 0..10, :a => 2).should be_a Array
    end

    it "should raise exception if invalid variable given" do
      model = Function.new { a * x }
      lambda{model.distribution(:i,[0,1,2,3,4,5])}.should raise_error
    end

    it "should raise exception if range not given as Array or Range" do
      model = Function.new { a * x }
      lambda{model.distribution(:x, 0,1,2,3,4,5)}.should raise_error
      lambda{model.distribution(:x, 0)}.should raise_error
      lambda{model.distribution(:x, 'string')}.should raise_error
    end

    it "should return correct distribution of points for basic linear function" do
      test_distribution = [[0,0],[1,2],[2,4],[3,6],[4,8],[5,10]]
      
      model   = Function.new { a * x }
      model.a = 2
      result  = model.distribution(:x, 0..5).should eql test_distribution
    end

    it "should return correct distribution with passing parameters as argument" do
      test_distribution = [[0,0],[1,2],[2,4],[3,6],[4,8],[5,10]]
      
      model   = Function.new { a * x }
      result  = model.distribution(:x, 0..5, :a => 2).should eql test_distribution
    end

    it "should return correct distribution of points for exponential function" do
      test_distribution = { 0 => 2.0, 1 => 0.735758882343, 2 => 0.270670566473, 3 => 0.0995741367357 }

      model   = Math.function { a * Math.exp(b * x) }
      model.a = 2
      model.b = -1
      result  = model.distribution(:x, 0..3)

      result.each do |x,y|
        y.should be_within(0.0000001).of(test_distribution[x])
      end
    end 
  
  end
end

