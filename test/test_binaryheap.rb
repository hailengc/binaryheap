# unit test for binaryheap
# magic_ball.rb
require 'minitest/autorun'
require 'binaryheap'

class BinaryHeapTest < Minitest::Test
  def test_init_with_no_parameter
    bh = BinaryHeap.new
    assert bh.data != nil
  end  
end