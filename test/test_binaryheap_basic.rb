require 'binaryheap'

class BinaryHeapTestBasic < Minitest::Test
  def test_basic_init_with_no_parameter
    bh = BinaryHeap.new
    refute_nil(bh.data)
    assert_equal(bh.data.size, 0)
  end  

  def test_basic_init_with_data
    data = {}
    assert_raises(BinaryHeap::ParameterError) do
      bh = BinaryHeap.new(data)
    end

    data = []
    bh = BinaryHeap.new(data)
    refute_nil(bh.data)
    assert_equal(bh.data.size, 0)

    data = [30, 20, 10, 5, 0]
    bh = BinaryHeap.new(data)
    assert_equal(bh.data.size, data.size)

    assert(heap_valid?(bh), "binary heap is not valid!")
  end

 private
  def heap_valid?(bh, comp=lambda{|parent, child| parent <=> child})
    data = bh.data 
    0.upto(data.size-1) do |i|
      lchild = data[l_idx(i)]
      rchild = data[r_idx(i)]

      if !lchild.nil?
        return false unless comp.call(data[i], lchild) >= 0
      end

      if !rchild.nil?
        return false unless comp.call(data[i], rchild) >= 0
      end
    end

    true
  end

  def l_idx(idx)
    2*idx + 1
  end

  def r_idx(idx)
    2*idx + 2
  end

end