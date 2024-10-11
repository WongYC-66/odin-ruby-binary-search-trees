class Node
  include Comparable
  attr_accessor(:data, :left, :right)

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
  
  def <=>(other)
    if other.kind_of?(Node)
      @data <=> other.data
    else
      @data <=> other
    end
  end

end

`
1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6345

                          8
                        /   \
                       4     67
                      / \   /  \
                     3   7 23   6345
                    /   /  /    /
                   1   5  9   324



`


class BinarySearchTree
  attr(:root)
  
  def initialize(arr)
    @root = build_tree(arr.to_set.to_a.sort!)
  end

  def build_tree(arr)
    return nil if arr.empty?
    return Node.new(arr.pop) if arr.length == 1

    centreVal = arr.slice!(arr.length / 2, 1)
    mid = arr.length.odd? ? arr.length / 2 : arr.length / 2 - 1
    leftTree = build_tree(arr.slice!(0, mid + 1))
    rightTree = build_tree(arr)

    root = Node.new(centreVal[0], leftTree, rightTree)
    return root
  end

  def insert(val, node = @root)
    return nil if node == val

    if node > val
      if !node.left
        node.left = Node.new(val)
        return
      end
      insert(val, node.left)
    else
      if !node.right
        node.right = Node.new(val)
        return
      end
      insert(val, node.right)
    end
  end

  def delete(val, node = @root, parent = nil, dir = nil)
    return nil if !node

    if node > val
      delete(val, node.left, node, 'left')
    elsif node < val
      delete(val, node.right, node, 'right')
    else
      # node == val
      child_count = 0
      node.left && child_count +=1
      node.right && child_count += 1
      # 3 cases:
      if child_count == 0     # case 1: no-child, just delete
        assign_child(parent, nil, dir)
      elsif child_count == 1  # case 2: 1-child, deleted node's child = parent new child
        if node.left
          assign_child(parent, node.left, dir)
        else
          assign_child(parent, node.right, dir)
        end
      else
        # case 3: 2-children, get the smallest in right-subtree, assign to deleted position
        next_inorder_successor = find_next_successor(node.right, node, 'right')
        node.data = next_inorder_successor.data
      end
    end
  end

  def assign_child(parent, node, dir)
    if !parent  # edge case where deleted node is the root, without parent
      @root = node
      return
    end

    if dir == 'left'
      parent.left = node
    else
      parent.right = node
    end
  end

  def find_next_successor(node, parent, dir)
    if(node.left)
      return find_next_successor(node.left, node, 'left')
    end
    if dir == 'left'
      parent.left = nil
    else
      parent.right = nil
    end
    return node
  end

  def find(val, node = @root)
    return nil if !node
    return node if node == val

    if node > val
      find(val, node.left)
    else
      find(val, node.right)
    end
  end


  def level_order(&fn)
    arr = []
    q = [@root]
    while(!q.empty?)
      curr = q.shift()
      arr.push(curr)
      q.push(curr.left) if curr.left
      q.push(curr.right) if curr.right
    end

    if fn
      arr.each {|node| fn.call(node) if fn} # fn.call = yield
      nil
    else
      arr.map {|node| node.data} 
    end
  end

  def inorder(&fn)
    def dfs(node, arr = [])
      return nil if !node
      dfs(node.left, arr)
      arr.push(node)
      dfs(node.right, arr)
      arr
    end

    arr = dfs(@root)

    if(fn)
      arr.each {|node| fn.call(node)}
      nil
    else
      arr.map {|node| node.data}
    end
  end


  def preorder(&fn)
    def dfs(node, arr = [])
      return nil if !node
      arr.push(node)
      dfs(node.left, arr)
      dfs(node.right, arr)
      arr
    end

    arr = dfs(@root)

    if(fn)
      arr.each {|node| fn.call(node)}
      nil
    else
      arr.map {|node| node.data}
    end
  end

  def postorder(&fn)
    def dfs(node, arr = [])
      return nil if !node
      dfs(node.left, arr)
      dfs(node.right, arr)
      arr.push(node)
      arr
    end

    arr = dfs(@root)

    if(fn)
      arr.each {|node| fn.call(node)}
      nil
    else
      arr.map {|node| node.data}
    end
  end

  def height(target_node)
    # find the target_node
    # curr = @root
    # while target_node != curr
    #   if curr > target_node
    #     curr = curr.left
    #   else
    #     curr = curr.right
    #   end
    # end

    # return 0 if(!curr)

    # find the longest path to a leaf node
    def dfs(node, h = 0, arr = [0])
      return arr if !node
      # leaf node
      if !node.left && !node.right
        arr.push(h)
        return arr
      end
      dfs(node.left, h + 1, arr)
      dfs(node.right, h + 1, arr)
      arr
    end
    
    # arr = dfs(curr)
    arr = dfs(target_node)
    return arr.max()
  end

  def depth(target_node, node = @root, d = 0)
    return nil if !node
    return d if node == target_node

    if node > target_node
      depth(target_node, node.left, d + 1)
    else
      depth(target_node, node.right, d + 1)
    end
  end

  def balanced?(node = @root)
    return true if !node 
    left_height = self.height(node.left)
    right_height = self.height(node.right)
    return false if (left_height - right_height).abs > 1

    return self.balanced?(node.left) && self.balanced?(node.right)
  end

  def rebalance()
    return nil if self.balanced?
    arr = self.level_order()
    @root = self.build_tree(arr.to_set.to_a.sort!)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end