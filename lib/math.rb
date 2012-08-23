require 'math/function'
require 'math/distribution'
require 'math/optimize/base'
require 'math/optimize/random_search'
require 'math/optimize/gradient_descent'

module Math

  def Math.function(options={},&block)
    Math::Function.new(options,&block)
  end

end