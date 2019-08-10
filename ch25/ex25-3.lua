--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.

	Our function is called 't_all'.  Check out the _it files for iterators that
make finding locals and upvalues easier.
	'flevel' points the iterator to start scanning in the proper scope, 
but the 'level' control variable (here omitted using '_') still starts
with the level as seen by Lua (e.g., 2 instead of 1).
]]

local locals = require "examples.local_it"
local upvalues = require "examples.upvalue_it"
local x = "the higher version of x"

local nice = "foo"

MESSAGE	= "I can be seen"

function t_all (co)
	local flevel = (co and 0) or 1
	local env -- for finding the _ENV to use with globals metatable
	
	local result = {}
	result.locals = {}
	result.upvalues = {}
	
	
	for _, ltable in locals(co, flevel) do
		table.insert(result.locals, ltable)
		
		for name, value in pairs(ltable) do
			if (name == "_ENV") and not env then
				env = value
			end
		end
	end
	
	for _, utable in upvalues(co, flevel) do
		table.insert(result.upvalues, utable)
		
		for name, value in pairs(utable) do
			if (name == "_ENV") and not env then
				env = value
			end
		end
	end
	
	result.globals = setmetatable({}, {__index = env})
	
	return result
end

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
