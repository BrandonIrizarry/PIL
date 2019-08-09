local tlocals = require "tlocals"
local tupvalues = require "tupvalues"
local tprint = require "tprint"

local nice = "foo"

function test ()
	local x = 1
	local y = 2
	local z = 3

	local tl = tlocals()
	tprint(tl)
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

local tl_c = tlocals(co)
local tu_c = tupvalues(co)
tprint(tl_c)
tprint(tu_c)

--[[
	tbc -- now figure out (shouldn't be too hard) to join these two tables
into one table, e.g., per inside flevel-call, or outside co-call:
{
	locals = <the local table>
	upvalues = <the upvalue table>
}

Or, perhaps better:

{
	locals = <the local table>
	upvalues = <the upvalue table>
	globals = {}
}

Then, you set that last table's metatable to be the _ENV seen at the lowest level by that
function or coroutine. tbc.
]]