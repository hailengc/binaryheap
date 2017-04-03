require_relative 'binaryheap_test'
require 'binaryheap'
require 'thread'
require 'time'

class BinaryHeapMultiThreadTest < BinaryHeapTest
  def test_mt_insert
    bh = BinaryHeap.new
    
    thread_count = 5
    insert_count = 10000
    thread_count.times.map do
    	Thread.new do
    		insert_count.times do
    			bh.insert(rand(-9999..9999))
    		end
    	end
    end.each(&:join)

    assert_equal(bh.size, thread_count*insert_count)
    assert(heap_valid?(bh), "heap is invalid")
  end  

  def test_mt_eject
    element_count = 10000
  	thread_count = 5

    data = element_count.times.map{rand(-9999..9999)}

    bh = BinaryHeap.new(data)
  	slots = Array.new(thread_count) { [] }
  	thread_count.times.map do |i|
  		Thread.new do
        element = bh.eject 
        until element.nil?
          slots[i].push element
          element = bh.eject
        end
      end
  	end.each(&:join)

    result = []
    slots.each do |slot| 
      assert(is_desc?(slot))
      result.concat(slot) 
    end

    assert_equal(result.size, data.size)
    assert_equal(result.sort!, data.sort!)
  end

 private
  def is_desc?(ary)
    (0..ary.size-2).each do |i|
      return false if ary[i] < ary[i+1]
    end
    true
  end
end