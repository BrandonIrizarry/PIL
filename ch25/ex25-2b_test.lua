local getvarvalue = require "ex25-1b"
local setvarvalue = require "ex25-2b"

function test_instance(varname, varvalue, level, co)
	if co == nil then
		level = level + 1
	end
	
	setvarvalue(varname, varvalue, level, co)
	local _type, _value = getvarvalue(varname, level, co)
	print(_type, _value, varvalue)
	assert(_value == varvalue)
end

a = "foo"

local uv = 0
function test ()
	local x = uv
	test_instance("x", -1, 1)
	test_instance("uv", -2, 1)
	test_instance("a", "bar", 1)
end

test()

function cave ()
	local inside = "inside the cave"
	coroutine.yield()
end

function spelunker ()
	local top = "just outside the cave"
	coroutine.yield()
	cave()
end


local co = coroutine.create(spelunker)

local status1, result1 = coroutine.resume(co)

if status1 then
	test_instance("top", "foo", 1, co)
	test_instance("top", "bar", 1, co)
else
	print(result1)
end

local s2, r2 = coroutine.resume(co)

if s2 then
	test_instance("top", "baz", 2, co)
	test_instance("top", "afuera", 2, co)
	test_instance("inside", "adentro", 1, co)
else
	print(r2)
end
