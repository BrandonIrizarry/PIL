--[[
	Exercise 14.2
	
	Modify the queue implementation  in Listing 14.2 so that both
indices return to 0 when the queue is empty.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch14/ex14-2.lua"] = nil
	dofile("/home/brandon/PIL/ch14/ex14-2.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

--[[

	Try an implementation where the indices reset to their original values
of first = 0, last = -1. 
	I'm stumped on how to make a decent implementation resetting both indices to zero,
and this one still has the main benefit gained from resetting the indices.
--]]

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
	
	if list.first > list.last then
		list.first, list.last = 0, -1
	end
	
	return value
end

function popLast (list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil
	list.last = last - 1
	
	if list.first > list.last then
		list.first, list.last = 0, -1
	end
	
	return value
end

function printList (list)
	local first, last = list.first, list.last

	fmt_write("first: %d\nlast: %d\n", first, last)
	if first > last then io.write("Empty") end
	
	for i = first, last do
		fmt_write(" %s", tostring(list[i]))
	end
	
	io.write("\n\n")
end

function test1 ()
	local L = listNew()
	printList(L)
	pushLast(L, "A")
	printList(L)
	pushFirst(L, "a")
	printList(L)
	pushLast(L, "B")
	printList(L)
	popFirst(L)
	printList(L)
	popFirst(L)
	printList(L)
	popFirst(L)
	printList(L)
end

function test2 ()
	local L = listNew()
	
	for i = 1, 50 do
		pushLast(L, "A")
	end
	
	printList(L)
	
	for i = 1, 49 do
		popFirst(L)
	end
	
	printList(L)
	
	popFirst(L)
	
	-- The indices have been reset.
	assert(L.first == 0 and L.last == -1)
	
	printList(L)
end

test2()
