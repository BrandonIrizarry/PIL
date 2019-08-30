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