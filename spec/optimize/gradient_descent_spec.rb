require 'math'

include Math

describe Optimize::GradientDescent do


	it "should find a solution for linear gradient using explicitly define candidate vector" do
		function = Math.function { 10 * x + 2 }

		solver = Optimize::GradientDescent.new
		solver.search_space[:x] = 100
		solver.objective_function = Proc.new { |vector| function.absolute_difference(32.0, vector) }

		solver.search[:vector][:x].should be_within(0.1).of(3)
	end

end