require 'thread'

# An implementation of standard binary heap data structure. 
# Internally, it uses an array as data store and a mutex for thread synchronization (insert and eject operations)
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
 	
 	# The constructor
  # @param data [Array] the existent Array data on which the binary heap will be built
  # @param block [Block] the comparator block, see examples.  
  #   default comparator is lambda {|parent, child| parent <=> child} which makes it a max binary heap.
  # @return [BinaryHeap] the Binary Heap instance
 	# @example A default max heap
 	#   bh = BinaryHeap.new
 	# @example A min heap
 	#   bh = BinaryHeap.new{|parent, child| child <=> parent}
 	# @example A max heap using self-defined comparator 
 	#   bh = BinaryHeap.new{|parent, child| parent.bigger_or_equal_than(child)}
	def initialize(data=nil, &block)
		@cmp = block || lambda{|parent, child| parent <=> child }
		@mutex = Mutex.new

		raise ParameterError.new("type of data must be Array or its subclass") unless data.nil? || data.is_a?(Array)
		@ary = data.nil? ? [] : build_from(data)
	end

	# Insert an element into the heap (heap will be adjusted automatically)
	# @param element [Object] the element to be inserted into the heap
	# @return [BinaryHeap] the binary heap instance itself
	def insert(element)
		@mutex.synchronize do
			@ary.push(element) 
			adjust(:bottom_up)
		end
		self
	end

	alias :push :insert

	# Eject the top(max or min) element of the heap (heap will be adjusted automatically)
	# @return [Object] the ejected element
	def eject
		@mutex.synchronize do
			return nil if @ary.empty?
			e = @ary.first
			@ary[0] = @ary.last
			@ary.pop
			adjust(:top_down)
			e
		end
	end

	# Return the the top(max or min) element of the heap
	def top 
		@ary.first
	end

	# Set the top element of the heap
	# @param element [Object] 
	# @note in most cases, this method should be used with the BinaryHeap#adjust method
	# @see BinaryHeap#adjust
	def top=(element)
		@ary[0] = element
	end

	# Return the underlying Aarray data 
	def data
		@ary
	end

	# Adjust the heap to make it in good shape
	# @param direction [Symbol] direction of adjustment, one of [:top_down, bottom_up]
	# @return [BinaryHeap] the binay heap instance itself
	# @note this method should be used carefully since it is not thread-safe, please check the implementation of BinaryHeap#eject and BinaryHeap#insert
	def adjust(direction = :top_down)
		return if @ary.size < 2
		case direction
			when :top_down
				parent_idx = 0
				until is_good?(parent_idx)
					child_idx = target_child_idx(parent_idx)
					swap(parent_idx, child_idx)
					parent_idx = child_idx
				end
			when :bottom_up
				child_idx = @ary.size - 1
				parent_idx = p_idx(child_idx)
				until child_idx == 0 || @cmp.call(@ary[parent_idx], @ary[child_idx]) >= 0
				 	swap(parent_idx, child_idx)
				 	child_idx = parent_idx
				 	parent_idx = p_idx(child_idx)
				end 
			else
				raise ParameterError.new("invalid direction type")
		end
		self
	end

	# Forward methods to underlying Array instance
	def method_missing(name, *args, &blcok)
		@ary.send(name, *args, &blcok)
	end

private
	def build_from(data)
		heap = BinaryHeap.new(&(@cmp))
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
