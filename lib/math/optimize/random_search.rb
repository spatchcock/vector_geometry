module Optimize

  class RandomSearch < Base

    def initialize(options={})
      super
      @candidate_vector = Proc.new { random_vector }
    end

    def search(iterations=nil)
      best = nil
      (iterations || default_iterations).times do |iter|
        candidate = {}
        candidate[:vector] = candidate_vector
        candidate[:cost]   = objective_function(candidate[:vector])

        best = candidate if best.nil? or candidate[:cost] < best[:cost]

        puts " > iteration: #{(iter+1)}\tbest=#{best[:cost]}\tvector=#{best[:vector]}"
      end

      puts "\nDone. Best Solution: cost = #{best[:cost]}, vector = #{best[:vector].inspect}"
      return best
    end

  end

end