require 'math'

include Math

describe Optimize::RandomSearch do


	it "should find a solution for linear gradient using explicitly define candidate vector" do
		function = Math.function { 10 * x + 2 }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(32.0, vector) }
		solver.candidate_vector   = Proc.new { { :x => rand * 20.0 }	}

		solver.search(500)[:vector][:x].should be_within(0.1).of(3)
	end

	it "should find a solution for linear gradient using search space convenience method" do
		function = Math.function { 10 * x + 2 }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(32.0, vector) }
		solver.search_space[:x] = 0..20

		solver.search(500)[:vector][:x].should be_within(0.1).of(3)
	end

	it "should find a solution for gradient and intercept using explicitly define candidate vector" do
		function = Math.function { 2 * x + c }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(18.0, vector) }
		solver.candidate_vector   = Proc.new { { :x => rand * 10.0, :c => rand * 10.0 }	}

		solution = solver.search(1000)[:vector]
		function.evaluate(solution).should be_within(0.1).of(18)
	end

	it "should find a solution for gradient and intercept using search space convenience method" do
		function = Math.function { 2 * x + c }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(18.0, vector) }
		solver.search_space[:x] = 0..10
		solver.search_space[:c] = 0..10

		solution = solver.search(1000)[:vector]
		function.evaluate(solution).should be_within(0.1).of(18)
	end

	it "should find a solution to exponential growth function" do
		function = Math.function { a * Math.exp(b * x) }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(50.0, vector) }
		solver.candidate_vector   = Proc.new { { :x => rand * 10.0, :a => rand * 10.0, :b => rand }	}

		solution = solver.search(1000)[:vector]
		function.evaluate(solution).should be_within(0.5).of(50)
	end

	it "should find a solution to exponential decay" do
		function = Math.function(:a => 20) { a * Math.exp(-b * x) }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(2.0, vector) }
		solver.candidate_vector   = Proc.new { { :x => rand * 10.0, :b => rand }	}

		solution = solver.search(1000)[:vector]
		function.evaluate(solution).should be_within(0.1).of(2)
	end

	it "should find a solution to polynomial" do
		function = Math.function { a0 * x + a1 * x**2 + a2 * x**3 + a4 * x**4 }

		solver = Optimize::RandomSearch.new
		solver.objective_function = Proc.new { |vector| function.absolute_difference(45.0, vector) }
		solver.candidate_vector   = Proc.new { { :x => rand * 100, :a0 => rand, :a1 => rand, :a2 => rand, :a4 => rand }	}

		solution = solver.search(10000)[:vector]
		function.evaluate(solution).should be_within(1.0).of(45.0)
	end

	context "default iterations"

	context "least squares" do

		it "should find a solution to simple least square problem" do
			function = Math.function(:variable => :x) { a * x }
			data     = Distribution.new([1,2,3,4, 5, 6, 7, 8, 9,10],
                                  [1,4,7,8,10,12,14,17,18,20])

			solver = Optimize::RandomSearch.new

			solver.objective_function = Proc.new do |vector|
				candidate = function.set(vector).distribution(data.x)
				candidate.sum_of_squares(data)
			end

			solver.candidate_vector = Proc.new { { :a => rand * 10.0 }	}

			solver.search()[:vector][:a].should be_within(0.1).of(2.0)
		end

		it "should find a solution to simple least square problem with intercept" do
			function = Math.function(:variable => :x) { a * x + c }
			data     = Distribution.new([1,2, 3, 4, 5, 6, 7, 8, 9,10],
				                          [6,9,12,13,15,17,19,22,23,25])

			solver = Optimize::RandomSearch.new

			solver.objective_function = Proc.new do |vector|
				candidate = function.set(vector).distribution(data.x)
				candidate.sum_of_squares(data)
			end

			solver.candidate_vector = Proc.new { { :a => rand * 50.0, :c => rand * 50.0 }	}

			solution = solver.search(10000)[:vector]
			solution[:a].should be_within(1.0).of(2.0)
			solution[:c].should be_within(1.0).of(5.0)
		end

		it "should find a solution to exponential least square problem" do
			function = Math.function(:variable => :x) { a * Math.exp(-b * x) }
			data     = Distribution.new([ 0, 5,10,15,20,25,30,35,40,45,50],
				                          [61,39,22,12, 9, 5, 2, 2, 2, 1, 1])

			solver = Optimize::RandomSearch.new

			solver.objective_function = Proc.new do |vector|
				candidate = function.set(vector).distribution(data.x)
				candidate.sum_of_squares(data)
			end

			solver.candidate_vector = Proc.new { { :a => rand * 100.0, :b => rand }	}

			solution = solver.search(10000)[:vector]
			solution[:a].should be_within(3.0).of(61.0)
			solution[:b].should be_within(0.01).of(0.1)
		end


	end

end