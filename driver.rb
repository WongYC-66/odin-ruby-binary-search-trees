require_relative('bst')

my_b_tree = BinarySearchTree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

my_b_tree.pretty_print()

p my_b_tree.balanced?

# Driver Test
random_arr = Array.new(15) { rand(1..100) }
test_tree = BinarySearchTree.new(random_arr)
test_tree.pretty_print()
p test_tree.balanced?
p test_tree.level_order
p test_tree.preorder
p test_tree.inorder
p test_tree.postorder

# Unbalance the tree by adding several numbers > 100
test_tree.insert(150)
test_tree.insert(125)
test_tree.insert(130)
test_tree.insert(200)
p test_tree.balanced?
test_tree.pretty_print()

# Balance the tree by calling #rebalance
test_tree.rebalance
p test_tree.balanced?

p test_tree.level_order
p test_tree.preorder
p test_tree.inorder
p test_tree.postorder
test_tree.pretty_print()

