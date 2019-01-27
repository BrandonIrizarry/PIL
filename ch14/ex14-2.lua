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

function listNew ()
	return {first = 0, last = 0}
end

function test_for_reset (list)
	local endpoints_equal = list.first == list.last
	
	if endpoints_equal then
		list.first = 0
		list.last = 0
	end
	
	return endpoints_equal
end

function pushFirst (list, value)
	local first = list.first
	list[first] = value
	list.first = first - 1
end

function pushLast (list, value)
	local last = list.last
	list[last] = value
	list.last = last + 1
end

function popFirst (list)
	local first, last = list.first, list.last
	
	if first == 0 and last == 0 then error("list is empty") end
	
	local value = list[first]
	list[first] = nil -- to allow garbage collection
	list.first = first + 1
	test_for_reset(list)
	return value
end

function popLast (list)
	local first, last = list.first, list.last
	
	if first == 0 and last == 0 then error("list is empty") end
	
	local value = list[last]
	list[last] = nil -- to allow garbage collection
	list.last = last - 1
	test_for_reset(list)
	return value
end

function printList (list)

	if test_for_reset(list) then 
		print("Empty")
		return
	end
	
	local first, last = list.first, list.last
	
	fmt_write("first:%d\n", first)
	fmt_write("last:%d\n", last)
	
	for i = first, last do
		fmt_write(" %s", tostring(list[i]))
	end
	
	io.write("\n\n")
end

L = listNew()
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