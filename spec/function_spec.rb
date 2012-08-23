require 'math'

include Math

describe Function do

  context "initialization" do

    it ".new constructor should initialize Function object" do
      model = Function.new { a * x + b * x ** 2 }
      model.should be_a Function
    end

    it "Math module constructor should initialize Function object" do
      model = Math.function { a * x + b * x ** 2 }
      model.should be_a Function
    end

  end

  context "instance variables" do

    it "basic polynomial should have instance variables representing all variables and parameters" do
      model = Function.new { a * x + b * x ** 2 }
      [:@a,:@b,:@x].each { |var| model.instance_variables.should include var }
    end

    it "exponential function should have instance variables representing all variables and parameters" do
      model = Function.new { a * Math.exp(-b * x) }
      [:@a,:@b,:@x].each { |var| model.instance_variables.should include var }
    end

    it "trigonometric function should have instance variables representing all variables and parameters" do
      model = Function.new { a / Math.sin(b * t) }
      [:@a,:@b,:@t].each { |var| model.instance_variables.should include var }
    end

    it "should raise error if any placeholder has the name of an instance method" do
      lambda{Function.new { x * variable + b * x ** 2 }}.should raise_error
      lambda{Function.new { x * v + tap * x ** 2 }}.should raise_error
      lambda{Function.new { x + b * set ** 2 }}.should raise_error

      # This daft example should be okay though
      Function.new do
        some_complicated_parameter_name + another_long_parameter_name * a_variable_with_another_name ** 2
      end.should be_a Function
    end

  end

  describe "singleton methods" do

    context "basic polynomial" do
  
      it "should have singleton methods for setting all variables and parameters" do
        model = Function.new { a * x + b * x ** 2 }
        [:a=,:b=,:x=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Function.new { a * x + b * x ** 2 }
        [:a,:b,:x].each { |var| model.singleton_methods.should include var }
      end

    end

    context "exponential function" do

      it "should have singleton methods for setting all variables and parameters" do
        model = Function.new { a * Math.exp(-b * x) }
        [:a=,:b=,:x=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Function.new { a * Math.exp(-b * x) }
        [:a,:b,:x].each { |var| model.singleton_methods.should include var }
      end

    end

    context "trigonometric function" do

      it "should have singleton methods for setting all variables and parameters" do
        model = Function.new { a * Math.sin(b * t) }
        [:a=,:b=,:t=].each { |var| model.singleton_methods.should include var }
      end

      it "should have singleton methods for getting all variables and parameters" do
        model = Function.new { a * Math.sin(b * t) }
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
      model   = Function.new { a * x + b * x**2 }
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
      model   = Function.new { a * Math.sin(t) }
      model.a = 2
      result  = model.evaluate(:t => 0).should eql 0.0
      result  = model.evaluate(:t => Math::PI / 2.0).should eql 2.0 
      result  = model.evaluate(:t => Math::PI).should be_within(0.00000001).of(0.0)
      result  = model.evaluate(:t => 3 * Math::PI / 2.0).should eql -2.0 
      result  = model.evaluate(:t => 2 * Math::PI).should be_within(0.00000001).of(0.0)
    end

  end

  context "variable and parameters" do
    
    it "should set the variable placeholder using a symbol argument if valid" do
      model = Function.new { a * x }
      model.variable = :x
      model.variable.should eql :x
    end

     it "should set the variable placeholder using a string argument if valid" do
      model = Function.new { a * x }
      model.variable = 'x'
      model.variable.should eql :x
    end

     it "should raise error if argument is not a placeholder" do
      model = Function.new { a * x }
      lambda{model.variable = 'z'}.should raise_error
    end

    it "should define all non-variable placeholders as parameters if variable defined" do
      model = Function.new { a * x }
      model.variable = 'x'
      model.parameters.should eql [:a]
    end

    it "should return all placeholders as parameters if no variable defined" do
      Function.new { a * x }.parameters.should eql [:a,:x]
    end

  end

  describe "#distribution" do

    it "should return a distribution if Array range given" do
      model = Function.new { a * x }
      model.distribution([0,1,2,3,4,5], :variable => :x).should be_a Distribution
    end

    it "should return a distribution if Range range given" do
      model = Function.new { a * x }
      model.distribution(0..10, :variable => :x, :a => 2).should be_a Distribution
    end

    it "should raise exception if invalid variable given" do
      model = Function.new { a * x }
      lambda{model.distribution([0,1,2,3,4,5], :variable => :i)}.should raise_error
    end

    it "should raise exception if range not given as Array or Range" do
      model = Function.new { a * x }
      lambda{model.distribution(0,1,2,3,4,5, :variable => :x)}.should raise_error
      lambda{model.distribution(0, :variable => :x)}.should raise_error
      lambda{model.distribution('string', :variable => :x)}.should raise_error
    end

    it "should return correct distribution of points for basic linear function" do
      test_distribution = [0,2,4,6,8,10]
      
      model   = Function.new { a * x }
      model.a = 2
      result  = model.distribution(0..5, :variable => :x)
      
      result.x.should eql (0..5).to_a
      result.y.should eql test_distribution
    end

    it "should return correct distribution with passing parameters as argument" do
      test_distribution = [0,2,4,6,8,10]
      
      model   = Function.new { a * x }
      result  = model.distribution(0..5, :variable => :x, :a => 2)

      result.x.should eql (0..5).to_a
      result.y.should eql test_distribution
    end

    it "should return correct distribution of points for exponential function" do
      test_distribution = [2.0, 0.735758882343, 0.270670566473, 0.0995741367357]

      model   = Function.new { a * Math.exp(b * x) }
      model.a = 2
      model.b = -1
      result  = model.distribution(0..3, :variable => :x)

      result.y.each_with_index {|x,i| x.should be_within(0.0000001).of(test_distribution[i]) }
    end 
  
  end

  context "integrate" do

    it "should integrate a simple constant function" do
      model = Function.new { 5 }
      model.integrate(0,10,1).should eql 50.0
    end

    it "should integrate a simple linear function" do
      model = Function.new(:variable => :x) { 2 * x + 2 }
      model.integrate(0,10,0.1).should be_within(0.1).of(120.0)
    end

     it "decreasing step size should increase accuracy of integration" do
      model = Function.new(:variable => :x) { 2 * x + 2 * x ** 2 }   

      model.integrate(0,10,2).should be_within(50.0).of(766.6)
      model.integrate(0,10,2).should_not be_within(10.0).of(766.6)

      model.integrate(0,10,1).should be_within(5.0).of(766.6)
      model.integrate(0,10,1).should_not be_within(1.0).of(766.6)

      model.integrate(0,10,0.1).should be_within(1.0).of(766.6)
      model.integrate(0,10,0.1).should_not be_within(0.1).of(766.6)

      model.integrate(0,10,0.01).should be_within(0.1).of(766.6)
      model.integrate(0,10,0.01).should_not be_within(0.01).of(766.6)

      model.integrate(0,10,0.001).should be_within(0.01).of(766.66)
    end


  end

end

