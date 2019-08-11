local t_all = require "ex25-3"
local x = "the higher version of x"

local nice = "foo"

MESSAGE	= "I can be seen"

print("\nAnother set of tests!")
local print = print
local pairs = pairs
local t_all = t_all
function foo (_ENV, a)
	print(a + b)
	print("This should be your answer: ", _ENV.b)
	local r = t_all()
	for k,v in pairs(r.locals) do
		print(k,v) 
	end
	print(r.globals.b)
end  -- _ENV is local, so to find such an _ENV, you need to scan for local variables.


foo({b = 14}, 12)

--print("\nEnd those tests")

function test ()
	local x = 1
	local y = 2
	local z = 3

	local r = t_all()
	print(r.globals.MESSAGE)
end

function second_trip ()
	local h = "baytown"
	
	coroutine.yield()
end

function travel ()
	local x = 0
	local w = nice
	second_trip ()
end

test()
co = coroutine.create(travel)

coroutine.resume(co)

local s = t_all(co)

print(s.locals[1].h)
print(s.upvalues[2].nice)
