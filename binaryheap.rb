require 'thread'

class BinaryHeap
	FIXNUM_MAX = ->{
	  if RUBY_PLATFORM == 'java'
	    2**63 - 1
	  else
	    2**(0.size * 8 - 2) - 1
	  end
	}.call

	class Error < RuntimeError
  end

  class HeapError < Error
  	def mesage
  		"Heap Error: #{self.to_s}"
  	end
  end

  class ParameterError < Error
  	def message
  		"Parameter Error: #{self.to_s}"
  	end
  end

	# options:
	#  data: existing array 
	#  max_size: max size constrain on underlying array length
	def initialize(option={}, &block)
		@mutex = Mutex.new

		data = option[:data] || option['data']
		@max_size = option[:max_size] || option['max_size'] || FIXNUM_MAX

		if data
			raise ParameterError.new("data exceeds max size") if data.length > max_size
			@ary = init_from_data(data)
		else
			@ary = []
		end 

		@cmp = block || ->(parent, child){ parent <=> child }
	end

	def insert(element)
		@mutex.synchronize do 
			raise HeapError.new("heap size exceeds max limitation") if @ary.size+1 > @max_size
			@ary.push(element) 
			adjust(false)
		end
		self
	end
	alias :push :insert

	def eject(element)
	end

	alias :pop :eject


	def size
		@ary.size
	end

 private
	def init_from_data(data)

	end

	def adjust(top_down = true)
		return if @ary.size < 2
		if top_down
			parent_idx = 0
			
			until is_good?(parent_idx)
				child_idx = target_child_idx(parent_idx)
				swap(parent_idx, child_idx)
				parent_idx = child_idx
			end
		else
			child_idx = @ary.size - 1
			until @cmp.call(@ary[get_parent_idx(child_idx)], @ary[child_idx]) >= 0 || child_idx == 0 
			 	swap(parent_idx, child_idx)
			 	child_idx = parent_idx
			end 
		end
	end

	def swap(i, j)
		temp = @ary[i]
		@ary[i] = @ary[j]
		@ary[j] = temp
	end

	def get_parent_idx(child_idx)
		child_idx%2 == 0 ? (child_idx-2)/2 : child_idx/2 
	end

	def l_idx(parent_idx)
		2*parent_idx + 1 
	end

	def r_idx(parent_idx)
		2*parent_idx + 2
	end

	def lchid(parent_idx)
		@ary[l_idx(parent_idx)]
	end

	def rchild(parent_idx)
		@ary[r_idx(parent_idx)]
	end

	def is_good?(idx)
		if !lchid(idx).nil?
			return false unless @cmp.call(@ary[idx], lchid(idx)) >= 0 
		end

		if !rchild(idx).nil?
			result false unless @cmp.call(@ary[idx], rchild(idx)) >= 0
		end

		true
	end

	# return the max/min child index
	def target_child_idx(parent_idx)
		return nil if lchid(parent_idx).nil? && rchild(parent_idx).nil?

		l = lchid(parent_idx)
		r = rchild(parent_idx)
		l_idx = l_idx(parent_idx)
		r_idx = r_idx(parent_idx)

		return r_idx if l.nil?
		return l_idx if r.nil?

		return @cmp.call(l, r) >= 0 ? l_idx : r_idx
	end

end


# bh = BinaryHeap.new
# bh.insert(2).insert(3)
# p bh.size

# p bh
