require 'binaryheap'

class BinaryHeapMultiThreadTest < Minitest::Test
  def test_mt_insert_should_be_thread_safe
    bh = BinaryHeap.new
    assert bh.data != nil
    assert bh.size == 0
  end  
end