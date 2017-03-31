require_relative 'binaryheap_test'
require 'binaryheap'
require 'thread'

class BinaryHeapMultiThreadTest < BinaryHeapTest
  def test_mt_insert
  	# insert operation should be thread-safe
    bh = BinaryHeap.new
    
    thread_count = 2
    insert_count = 100
    thread_count.times.map do
    	Thread.new do
    		insert_count.times do
    			bh.insert(rand(-9999..9999))
    		end
    	end
    end.each(&:join)

    assert_equal(bh.size, 2*insert_count)
    assert(heap_valid?(bh), "heap is invalid")
  end  

  def test_mt_eject
  	# eject should be thread-safe  
  	data = 10.times.map{rand(-9999..9999)}
  	bh = BinaryHeap.new(data)
  	thread_count = 5
  	result = []
  	thread_count.times.map do
  		Thread.new do
  			result << bh.eject until bh.empty? 
  		end
  	end.each(&:join)
  	p result
  end
end