local get_vt = require "ex25-3b"

-- This has to be in its own scope, or else references to 'pairs' and 'print' 
-- later on in this test-suite bafflingly don't trigger a reference to an _ENV table.

local function test_instance (name, expected, level, co)	
	level = level or 1
	
	if co == nil then
		level = level + 1
	end
	
	local vt = get_vt(level, co)
	
	local actual = vt[name]
	
	local status = (actual == expected) and "equal" or "not equal"
	print("actual:", actual, "expected:", expected, "status:", status)
	assert(status == "equal")
end

local function see (level, co)
	level = level or 1
	
	if co == nil then
		level = level + 1
	end
	
	local vt = get_vt(level, co)
	
	io.write("\n\n")
	for k,v in pairs(vt) do
		print(k,v)
	end
end

do
	local print = print
	local pairs = pairs
	local next = next
	local get_vt = get_vt

	local function foo (_ENV, a)
		print "Test 'foo', a function with _ENV passed as its first parameter"
		test_instance("b", 14)
		
		see()
	end


	foo({b = 14}, 12)
end

local function test ()
	print("\nTest a second, non-coroutine function.")
	local x, y, z = 0, 1, 2
		
	print "\nDo we have 'print'? (non-coroutine)"
	test_instance("print", print)
	
	print "\nDo we have 'pairs'? (non-coroutine)"
	test_instance("pairs", pairs)
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

local status1, result1 = coroutine.resume(co)
 
if status1 then
	test_instance("h", "baytown", 1, co)
	test_instance("x", 0, 2, co)
else
	print(result1)
end