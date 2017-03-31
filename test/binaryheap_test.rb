class BinaryHeapTest < Minitest::Test
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