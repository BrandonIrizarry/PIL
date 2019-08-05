--[[
	Exercise 25.2
	
	Write a function 'setvarvalue' similar to 'getvarvalue' (Listing 25.1)
]]


function get_local_idx (name, level, co)
	level = (level or 1) + 1
	
	for i = 1, math.huge do
		local n = (co and debug.getlocal(co, level - 1, i)) or debug.getlocal(level, i)
		if not n then break end
		if n == name then return i end
	end
end

function get_upvalue_idx (name, level, co)
	level = (level or 1) + 1
	
	local func = co and debug.getinfo(co, level - 1, "f").func or debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local n = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return i end
	end
end


function setvarvalue (name, value, level, isenv, co)
	level = (level or 1) + 1
	
	local local_idx = get_local_idx(name, level, co)

	if local_idx then
		if co then
			debug.setlocal(co, level - 1, local_idx, value)
		else
			debug.setlocal(level, local_idx, value)
		end
		return "local"
	end
	
	local upvalue_idx = get_upvalue_idx(name, level, co)
	
	if upvalue_idx then
		if co then
			debug.setupvalue(co, level - 1, upvalue_idx, value)
		else
			debug.setupvalue(level, local_idx, value)
		end
		return "upvalue"
	end

	local env_as_local = get_local_idx("_ENV", level, co)
	-- tbc -- redesign, since it looks like you're about to duplicate the
	-- above code.
	
end


a = 5
c = nil -- 'nil', but the explicit declaration makes this test fall through ('b' will fail, though)

local uv = 15
local vw = 21

function message (x)
	a = a - 1
	local x = vw
	local y = 4
	print("inside 'message', vw", get_upvalue_idx("vw", 1))
	print("inside 'message', x:", get_local_idx("x", 1))
	coroutine.yield(x)
end

function print_many ()
	a = a - 1
	local x = uv 
	coroutine.yield()
	message()
end

co = coroutine.create(print_many)

coroutine.resume(co)

print("after first resume, x:", get_local_idx("x", 1, co))
print("after first resume, uv:", get_upvalue_idx("uv", 1, co))

coroutine.resume(co)

print("after second resume, y:", get_local_idx("y", 1, co))
print(debug.getlocal(co, 1, 2))
--[=[
function setvarvalue (name, value, level, isenv, co)

	level = (level or 1) + 1

	local diff = isenv and 2 or 1

	--	print"try local variables"
	for i = 1, math.huge do
		local n, v
		
		if co then
			debug.setlocal(co, level - diff, i, value)
		else
			n,v = debug.setlocal(level, i)
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
--]=]

--[[
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
--]]