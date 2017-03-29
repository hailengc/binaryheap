require 'binaryheap'

class BinaryHeapTest < Minitest::Test
  def test_basic_init_with_no_parameter
    bh = BinaryHeap.new
    refute_nil(bh.data)
    assert_equal(bh.data.size, 0)
  end  

  def test_basic_init_with_data
  	data = []
  	bh = BinaryHeap.new(data)
  	refute_nil(bh.data)
  	assert_equal(bh.data.size, 0)
  end

 private

end