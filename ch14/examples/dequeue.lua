function reload ()
	package.loaded["/home/brandon/PIL/ch14/examples/dequeue.lua"] = nil
	dofile("/home/brandon/PIL/ch14/examples/dequeue.lua")
end

function listNew ()
	return {first = 0, last = -1}
end

function pushFirst (list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function pushLast (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function popFirst (list)
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil
	list.first = first + 1
	return value
end

function popLast (list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil
	list.last = last - 1
	return value
end

function printList (list)
	local first, last = list.first, list.last
	
	if first > last then print("Empty") end
	
	for i = first, last do
		io.write(list[i], " ")
	end
	
	io.write(string.format("\nfirst index: %d\nlast index: %d\n", first, last))
end

L = listNew()

printList(L)

pushFirst(L, "a")
pushFirst(L, "b")
pushFirst(L, "c")

printList(L)

pushLast(L, "d")
pushLast(L, "e")
pushLast(L, "f")

printList(L)

popFirst(L)
popFirst(L)
popLast(L)
popLast(L)
popLast(L)

printList(L)
popLast(L)

printList(L)
--[[
pushLast(L, "A")
pushLast(L, "B")
pushLast(L, "C")
printList(L)
popFirst(L)
popFirst(L)
printList(L)
pushFirst(L, "Z")
pushFirst(L, "Y")
printList(L)
popLast(L)
printList(L)
popFirst(L)
printList(L)
--]]