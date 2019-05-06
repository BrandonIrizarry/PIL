local Tree = {}

function Tree:new (key)
	self.__index = self
	local raw_tree = {key = key}
	return setmetatable(raw_tree, self)
end


tree = Tree:new(42)

tree.left = Tree:new(41)
tree.right = Tree:new(45)


function preorder (node)
	if node then 
		preorder(node.left)
		
		-- Notice that we're yielding the value, not the node!
		coroutine.yield(node.key)
		
		preorder(node.right)
	end
end

-- create an iterator
function preorder_iterator (tree)
	return coroutine.wrap(function ()
		preorder(tree)
		return nil
	end)
end

for key in preorder_iterator(tree) do
	print(key)
end