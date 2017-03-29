require 'binaryheap'

class BinaryHeapTest < Minitest::Test
  def test_basic_init_with_no_parameter
    bh = BinaryHeap.new
    assert bh.data != nil
    assert bh.size == 0
  end  
end