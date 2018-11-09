# Binaryheap

A standard [binary heap](https://en.wikipedia.org/wiki/Binary_heap) data structure implementation in ruby as a gem. 
Internally it uses an array as data store and a mutex to keep insert and eject opeations **thread-safe** (both on CRuby and JRuby).

## See [Rubydoc](http://www.rubydoc.info/gems/binaryheap/BinaryHeap)

## Install

`gem install binaryheap`

## Usage

- By default, an empty **max** heap is created:

  `bh = BinaryHeap.new`

- To create a **min** heap:

  `bh = BinaryHeap.new{|parent, child| child <=> parent}`

- To create from an existent array:

  ```ruby
    array = [-2, 40, 13, 88]

    bh = BinaryHeap.new(array)

    until bh.empty?

      p bh.eject  #=> 88, 40, 13, -2

    end

  ```

* You can custom a comparator which returns negative, zero or positive values based on comparision result:

  ```ruby
    bh = BinaryHeap.new do |parent, child| 

      if parent.greater_than(child)

        1

      elsif parent.equal_to(child)

        0

      else 

        -1

      end

    end

  ```

- Use insert (alias push) and eject to add into or remove element from the heap:

  ```ruby
    bh = BinaryHeap.new

    bh.insert(-3).insert(6).insert(-5).insert(17)

    p bh.size     #=> 3

    # get the underlying array data

    p bh.data     #=> [17, 6, -5, -3]

    until bh.empty?

      p bh.eject  #=> 17, 6, -3, -5

    end

  ```

- All Array methods will be forwarded to the underlying array data member:

  ```ruby
    bh = BinaryHeap.new(10.times.map{rand (1..99)})

    p bh.size  # => 10

    p bh.first # same as bh.top, returns the biggest number in this case

  ```

## Issues Report and Contribute

Please raise issues or send me pull requests.

## Author

Hailong Cao ( hailengc@gmail.com | [twitter](https://twitter.com/hailengc) )

## License and Copyrights

[MIT License](https://choosealicense.com/licenses/mit/)  
Copyright (c) 2017 Hailong Cao
