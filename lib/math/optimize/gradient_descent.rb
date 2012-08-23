module Optimize

  class GradientDescent < Base

    attr_accessor :step_size, :momentum_step_size, :precision

    def initialize(options={})
      super
      @precision = 0.001
      @step_size = 0.0001
      @candidate_vector = Proc.new { |current_vector| descent_vector(current_vector) }
    end

    def search
      error = @precision

      previous_candidate, last_candidate, candidate = nil

      until error < @precision do

        previous_candidate = last_candidate || bootstrap_candidate
        last_candidate     = candidate      || bootstrap_candidate

        candidate = {}
        candidate[:vector] = downslope_vector(last_candidate,previous_candidate)
        candidate[:cost]   = objective_function(candidate[:vector])

        error = (candidate[:cost] - previous_candidate[:cost]).abs

        puts " > cost=#{candidate[:cost]}\tvector=#{candidate[:vector]}\terror=#{error}"
      end

      puts "\nDone. Best Solution: cost = #{candidate[:cost]}, vector = #{candidate[:vector].inspect}"
      return candidate
    end

    def bootstrap_candidate
      candidate = {}
      candidate[:vector] = random_vector
      candidate[:cost]   = objective_function(candidate[:vector])
      return candidate
    end

    def downslope_vector(last,previous)
      vector = @search_space.map do |param,space|
        slope = (last[:cost] - previous[:cost])/(last[:vector][param] - previous[:vector][param])
        [param, last[:vector][param] - @step_size * slope]
      end

      Hash[vector] 
    end

  end

end