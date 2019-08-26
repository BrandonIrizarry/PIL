local getvarvalue = require "ex25-1"


local function test_instance(varname, tshould, vshould, level, co)
	if not co then
		level = level + 1
	end
	
	local vartype, varvalue = getvarvalue(varname, level, co)
	assert(vartype == tshould)
	assert(varvalue == vshould)
	print(string.format("name: %-5s type: %-10s value: %s", varname, vartype, varvalue))
end

a = 5
c = nil -- differentiate from nonexistent global 'b' when "strict" is enabled

local uv = 15
local vw = 21

local function message (x)
	a = a - 1
	local x = uv
	coroutine.yield(x)
end



local function test1 ()
	a = a - 1
	local x = vw
	test_instance("x", "local", 21, 1)
	coroutine.yield()
	test_instance("_ENV", "upvalue", _ENV, 1)
	message()
end

co = coroutine.create(test1)

coroutine.resume(co)


test_instance("x", "local", vw, 1, co)
test_instance("a", "global", 4, 1, co)

coroutine.resume(co)

test_instance("x", "local", vw, 2, co)
test_instance("x", "local", uv, 1, co)
test_instance("vw", "upvalue", vw, 2, co)
test_instance("uv", "upvalue", uv, 1, co) 
test_instance("a", "global", 3, 1)
test_instance("b", "global", nil, 1)
test_instance("c", "global", nil, 1)
test_instance("a", "global", 3, 1, co)
test_instance("a", "global", 3, 2, co)

local print = print
local getvarvalue = getvarvalue

local function foo (_ENV, a)
	test_instance("b", "global", 14, 1)
	test_instance("a", "local", 12, 1)
	test_instance("_ENV", "local", _ENV, 1)
end 


foo({b = 14}, 12)