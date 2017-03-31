require_relative 'binaryheap_test'
require 'binaryheap'

class BinaryHeapTestBasic < BinaryHeapTest
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

  def test_basic_insert
    count = 100
    # max heap
    bh = BinaryHeap.new
    count.times do
      bh.insert rand(-9999..9999)
    end
    assert_equal(bh.size, count)
    assert(heap_valid?(bh), "max heap invalid")

    # min heap 
    cmp = lambda{|parent, child| child <=> parent} 
    bh = BinaryHeap.new(&cmp)
    count.times do
      bh.insert rand(-9999..9999)
    end
    assert_equal(bh.size, count)
    assert(heap_valid?(bh, cmp), "min heap invalid")
  end


  def test_basic_eject
    # ensure not crash when bh is empty
    bh = BinaryHeap.new
    assert_nil(bh.eject)
    assert_equal(bh.size, 0)

    count = 100
    # max heap 
    data = count.times.map{rand(-9999..9999)}
    bh = BinaryHeap.new(data)
    data.sort! {|a, b| b <=> a}
    data.each do |e|
      assert_equal(bh.eject, e)
    end
    # min heap
    data = count.times.map{rand(-9999..9999)}    
    bh = BinaryHeap.new(data) {|parent, child| child <=> parent}
    data.sort!
    data.each do |e|
      assert_equal(bh.eject, e)
    end
  end
end