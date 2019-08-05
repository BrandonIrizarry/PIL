--[[
	Exercise 25.1
	
	Adapt 'getvarvalue' (Listing 25.1) to work with different coroutines
(like the functions from the debug library.
]]

function getvarvalue (name, level, isenv, co)
	local value
	local found = false
	
	level = (level or 1) + 1

	local diff = isenv and 2 or 1

	--	print"try local variables"
	for i = 1, math.huge do
		local n, v
		
		if co then
			n,v = debug.getlocal(co, level - diff, i)
		else
			n,v = debug.getlocal(level, i)
		end
		
		if not n then break end
		
		if n == name then
			value = v
			found = true
		end
	end
	
	if found then return "local", value end
	
	--print"try non-local variables"
	local func = co and debug.getinfo(co, level - diff, "f").func or debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return "upvalue", v end
	end
	
	if isenv then return false end -- avoid loop
	
--	print"not found; get value from the environment"
	local _, env = getvarvalue("_ENV", level, true, co)
	if env then
		-- "strict" won't let us access an undeclared 'name' in _ENV, so...
		-- NB: This works when "strict" isn't set, too.
		local status, result = pcall(function () return env[name] end)
		if status then 
			return "global", env[name]
		else
			return string.format("'%s' not declared", name)
		end
	else
		return "no env variable"
	end
end

a = 5
c = nil -- 'nil', but the explicit declaration makes this test fall through ('b' will fail, though)

local uv = 15
local vw = 21

function message (x)
	a = a - 1
	local x = vw
	coroutine.yield(x)
end

function print_many ()
	a = a - 1
	local x = uv 
	local x = vw
	coroutine.yield()
	message()
end

co = coroutine.create(print_many)

coroutine.resume(co)

print(getvarvalue("x", 1, false, co))
print(getvarvalue("a", 1, false, co))

coroutine.resume(co)
print(getvarvalue("x", 1, false, co))
print(getvarvalue("x", 2, false, co))
print(getvarvalue("uv", 2, false, co))
print(getvarvalue("vw", 1, false, co))
print(getvarvalue("a", 1, false))
print(getvarvalue("b", 1, false))
print(getvarvalue("c", 1, false))
print(getvarvalue("a", 1, false, co))

print(getvarvalue("a", 2, false, co))

--[[
t = {x = 12}
print(getvarvalue(x))
]]

print("\nAnother set of tests!")
local print = print
local getvarvalue = getvarvalue
function foo (_ENV, a)
	print(a + b)
	print("This should be your answer: ", _ENV.b)
	print(getvarvalue("b"))
end  -- _ENV is local, so to find such an _ENV, you need to scan for local variables.


foo({b = 14}, 12)