require 'math_function/function'
require 'math_function/distribution'

module Math

  def Math.function(options={},&block)
    Math::Function.new(options,&block)
  end

end