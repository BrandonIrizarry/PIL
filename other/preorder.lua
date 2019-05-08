
local Tree = {}

function Tree:new (key)
	self.__index = self
	local raw_tree = {key = key}
	return setmetatable(raw_tree, self)
end


tree = Tree:new(42)

tree.left = Tree:new(41)
tree.right = Tree:new(45)

tree2 = Tree:new(99)
tree2.left = Tree:new(32)
tree2.right = Tree:new(102)

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

-- Use a for-loop to print all tree-keys.
for key in preorder_iterator(tree) do
	print(key)
end


function merge (t1, t2)
	local it1 = preorder_iterator(t1)
	local it2 = preorder_iterator(t2)
	local v1 = it1()
	local v2 = it2()
	
	while v1 or v2 do
		if v1 ~= nil and (v2 == nil or v1 < v2) then
			print(v1)
			v1 = it1()
		else
			print(v2)
			v2 = it2()
		end
	end
end


merge(tree, tree2)