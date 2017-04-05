# Binaryheap

## About

A standard [binary heap](https://en.wikipedia.org/wiki/Binary_heap) data structure implementation in ruby.  
Internally, it uses an array as data store and a mutex to keep insert and eject opeations thread-safe (both on CRuby and JRuby).  

## [rubydoc](http://www.rubydoc.info/gems/binaryheap/1.0.1)

## Install
```
  gem install binaryheap
```

## Usage
By default, an empty **max** binary heap is created: 
```
  bh = BinaryHeap.new
```
To create a **min** binary heap:
```
  bh = BinaryHeap.new{|parent, child| child <=> parent}
```
You can assign a self-defined comparator which returns negative, zero or positive values based on comparision result:
```
  bh = BinaryHeap.new do |parent, child| 
    if parent.greater_than(child)
      return 1
    elsif parent.equal_to(child)
      return 0
    else 
      return -1
    end
  end
```
Use insert (alias push) and eject to add into or remove element from the heap:
```
  bh = BinaryHeap.new
  bh.insert(-3).insert(6).insert(-5).insert(17)
  p bh.size     #=> 3
  # get the underlying array data
  p bh.data     #=> [17, 6, -5, -3]
  until bh.empty?
    p bh.eject  #=> 17, 6, -3, -5
  end
```
You can also create a binary heap based on existent array data:
```
  array = [-2, 40, 13, 88]
  bh = BinaryHeap.new(array)
  until bh.empty?
    p bh.eject  #=> 88, 40, 13, -2
  end
```
All array methods will be forwarded to the underlying array data member:
```
  bh = BinaryHeap.new(10.times.map{rand (1..99)})
  p bh.size  # => 10
  p bh.first # same as bh.top, returns the biggest number in this case
```
## Example
Find the kth max element in an array:
```
  def find_kth_max(array, k)
    return nil if array.size < k

    i = 0
    bh = BinaryHeap.new
    until bh.size == k
      bh.insert(array[i])
      i += 1
    end

    (i..array.size-1).each do |j|
      e = array[j]
      if e < bh.top
        # Instead of using insert and eject which automatically adjust the heap, you can fully control the heap operation:
        # step 1: replace the root (max/min)
        bh.top = e
        # step 2: adjust the heap with direction (:top_down or :bottom_up) 
        bh.adjust(:top_down)
      end
    end

    bh.top
  end
```
## Issues Report and Contribute
Please raise issues or send me pull requests.  


## Author
Hailong Cao ( hailengc@gmail.com | [twitter](https://twitter.com/hailengc) )

## License and Copyrights
[MIT License](https://choosealicense.com/licenses/mit/)  
Copyright (c) 2017 Hailong Cao
