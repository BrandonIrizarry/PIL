local get_vt = require "ex25-3"

-- This has to be in its own scope, or else references to 'pairs' and 'print' 
-- later on in this test-suite bafflingly don't trigger a reference to an _ENV table.
do
	local print = print
	local pairs = pairs
	local next = next
	local get_vt = get_vt

	local function foo (_ENV, a)
		print("Test 'foo', a function with _ENV passed as its first parameter")
		local vt = get_vt(nil, 1)
		
		for name, value in pairs(vt.locals) do
			print(name, value)
		end
		
		print("This was included with local _ENV as a free reference:", vt.globals.b)
	end


	foo({b = 14}, 12)
end

local function test ()
	print("\nTest a second, non-coroutine function.")
	local x, y, z = 0, 1, 2
	
	local vt = get_vt(nil, 1)
		
	print("\nSee globals:")
	for k,v in pairs(vt.globals) do
		print(k,v)
	end
	print("But 'print' is a global here:")
	print(vt.globals.print)
	
	print("\nSee locals:")
	for n,v in pairs(vt.locals) do
		print(n,v)
	end

	print("\nSee upvalues:")
	for n,v in pairs(vt.upvalues) do
		print(n,v)
	end
	
	print("\n'pairs' is visible here:", vt.globals.pairs)
end

test()

local function second_trip ()
	local h = "baytown"
	
	coroutine.yield()
end

local function travel ()
	local x = 0
	second_trip()
end

local co = coroutine.create(travel)

-- Now we really have to watch out for this, b/c of "strict.lua"!
local status1, result1 = coroutine.resume(co)
 
if status1 then
	local vt_co = get_vt(co, 1)

	print("\nTest coroutine's locals.")
	for name, value in pairs(vt_co.locals) do
		print(name, value)
	end

	print("\nTest coroutine's upvalues.")
	for name, value in pairs(vt_co.upvalues) do
		print(name, value)
	end
else
	print(result1) -- hopefully, an error message
end


