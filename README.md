Vector geometry
========

Author: Andrew Berkeley (andrew.berkeley.is@googlemail.com)

Introduction
------------
This library provides an interface for handling vector geometry in 2- and 3-dimensional space as well as specific support for geometries on the surface of a sheroid, e.g. Earth.

Basic vector operations can be performed as follows.

Initialize a vector.

```ruby
  # 2D - pass x, y
  vector = Geometry::Vector.new(15,20)

  # 3D - pass x, y, z
  vector = Geometry::Vector.new(15,20,4)

  # 2D - pass magnitude and angle 
  vector = Geometry::Vector.from_polar(25, Math::PI)
```

Vector attributes.

```ruby
  vector = Geometry::Vector.new(15,20,4)

  vector.x                                    #=> 15
  vector.y                                    #=> 20
  vector.z                                    #=> 4

```

Vector operations.

```ruby

  vector = Geometry::Vector.new(3,4,5)

  # Magnitude
  vector.magnitude                            #=> 7.0710678118654755

  # Normalize
  vector.normalize                            #=> <Vector [0.4242640687119285, 0.565685424949238, 0.7071067811865475]>

  vector_1 = Geometry::Vector.new(2,2,1)
  vector_2 = Geometry::Vector.new(2,3,10)

  # Addition
  vector_1 + vector_2                         #=> <Vector [4.0, 5.0, 11.0]>

  # Subtraction
  vector_1 - vector_2                         #=> <Vector [0.0, -1.0, -9.0]>

  # Multiply by scalar value
  vector_1 * 4                                #=> <Vector [8.0, 8.0, 4.0]>

  # Divide by scalar value
  vector * 4                                  #=> <Vector [0.5, 0.5, 0.25]>

  # Calculate dot product of 2 vectors
  vector_1.dot(vector_2)                      #=> 20.0

  # Calculate cross product of 2 vectors
  vector_1.cross(vector_2)                    #=> <Vector [17.0, -18.0, 2.0]>

  # Calculate angle between 2 vectors (in radians)
  vector_1.angle(vector_2)                    #=> 0.8929110789963546 

```

Compare vectors.

```ruby
  
  # Are two vectors parallel or orthogonal?
  vector_1 = Geometry::Vector.new(10,0,0)
  vector_2 = Geometry::Vector.new(20,0,0)
  vector_3 = Geometry::Vector.new(0,10,0)

  vector_1.parallel?(vector_2)                #=> true
  vector_1.parallel?(vector_3)                #=> false

  vector_1.orthogonal?(vector_2)              #=> false
  vector_1.orthogonal?(vector_3)              #=> true

  # Are two vectors equal
  vector_1 == vector_2                        #=> false
```

Contributing
------------

If you find a bug or think that you improve on the code, feel free to contribute.

You can:

* Send the author a message ("andrew.berkeley.is@googlemail.com":mailto:andrew.berkeley.is@googlemail.com)
* Create an issue
* Fork the project and submit a pull request.


License
-------

© Copyright 2012 Andrew Berkeley.

Licensed under the MIT license (See COPYING file for details)