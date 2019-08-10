local tlocals = require "tlocals"
local tupvalues = require "tupvalues"
local tprint = require "tprint"

local nice = "foo"

function compound (co)
	local c = {}
	
	c.locals = tlocals(co, 2)
	c.upvalues = tupvalues(co, 2)
	c.globals = setmetatable({}, 
	
	return c
end

function test ()
	local x = 1
	local y = 2
	local z = 3

	--local tl = tlocals()
	local t = compound()
	--tprint(t.locals)
	local tw = t.upvalues[3]
	print(type(tw))
	local count = 0
	for k,v in pairs(tw) do
		print(k,v)
		count = count + 1
	end
	print("count:", count)
	--[[
	local things = debug.getinfo(3, "Sf")
	local f  = things.func
	local w = things.what
	print(type(f))
	--print(type(debug.getupvalue(f, 1))) -- C function issues?!
	print(w)
	--]]
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
--[[
local tl_c = tlocals(co)
local tu_c = tupvalues(co)
tprint(tl_c)
tprint(tu_c)
--]]
--[=[
t = compound(co)
tprint(t.locals)
tprint(t.upvalues)