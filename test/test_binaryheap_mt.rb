require_relative 'binaryheap_test'
require 'binaryheap'

class BinaryHeapMultiThreadTest < BinaryHeapTest
  def test_mt_insert
  	# insert operation should be thread-safe
    # bh = BinaryHeap.new
  end  

  def test_mt_eject
  	# eject should be thread-safe  
  end
end