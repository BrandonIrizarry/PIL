list = nil

function add (value)
	list = {next_node = list, value = value}
end

local function getnext (_, node)
	return node.next_node
end

function traverse (list)
	return getnext, nil, list
end

add(100)
add(200)
add(300)

list_orig = list

while list do
	print(list.value)
	list = list.next_node
end

print()

for node in traverse(list_orig) do
	print(node.value)
end
