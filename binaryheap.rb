require 'thread'

class BinaryHeap
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

	def initialize(data=nil, &block)
		@cmp = block || ->(parent, child){ parent <=> child }
		@mutex = Mutex.new

		raise ParameterError.new("type of data must be Array or its subclass") unless data.nil? || data.is_a?(Array)
		@ary = data.nil? ? [] : build_from(data)
	end

	def insert(element)
		@mutex.synchronize do
			@ary.push(element) 
			adjust(:bottom_up)
		end
		self
	end
	alias :push :insert

	def eject
		@mutex.synchronize do
			return nil if empty?
			e = @ary.first
			@ary[0] = @ary.last
			@ary.pop
			adjust(:top_down)
			e
		end
		self
	end

	def adjust(direction = :top_down)
		return if @ary.size < 2
		if direction == :top_down
			parent_idx = 0
			until is_good?(parent_idx)
				child_idx = target_child_idx(parent_idx)
				swap(parent_idx, child_idx)
				parent_idx = child_idx
			end
		elsif direction == :bottom_up
			child_idx = @ary.size - 1
			parent_idx = p_idx(child_idx)
			until child_idx == 0 || @cmp.call(@ary[parent_idx], @ary[child_idx]) >= 0
			 	swap(parent_idx, child_idx)
			 	child_idx = parent_idx
			 	parent_idx = p_idx(child_idx)
			end 
		end
	end

	def top 
		@ary.first
	end

	def data
		@ary
	end

	# forward array methods 
	def method_missing(name, *args, &blcok)
		@ary.send(name, *args, &blcok)
	end

 private
	def build_from(data)
		heap = BinaryHeap.new
		data.each{|e| heap.insert e}
		heap.data
	end

	def swap(i, j)
		temp = @ary[i]
		@ary[i] = @ary[j]
		@ary[j] = temp
	end

	def p_idx(child_idx)
		return nil if child_idx == 0
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
			return false unless @cmp.call(@ary[idx], rchild(idx)) >= 0
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
