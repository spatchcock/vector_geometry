module Optimize

  class Base

    attr_reader :search_space

    def initialize(options={})
      @search_space = {}
      @objective_function = nil
      @candidate_vector   = nil
    end

    def default_iterations
      @default_iterations || 1000
    end

    def default_iterations=(number)
      @default_iterations = number
    end

    def objective_function(candidate_vector)
      @objective_function.call(candidate_vector)
    end

    def objective_function=(block)
      @objective_function = block
    end

    def candidate_vector
      @candidate_vector.call
    end

    def candidate_vector=(block)
      @candidate_vector = block
    end

    protected

    def random_vector
      vector = @search_space.map do |variable, search_space| 
        [variable, random_candidate(search_space)]
      end

      Hash[vector] 
    end

    def random_candidate(search_space)
      return rand * search_space                                             if search_space.is_a? Fixnum 
      return search_space.min + rand * (search_space.max - search_space.min) if search_space.is_a? Range
      # handle probability density function                                  if search_space.is_a? Distribution
      # handle probability density function                                  if search_space.is_a? Function
    end

  end

end