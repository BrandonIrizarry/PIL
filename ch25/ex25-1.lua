--[[
	Exercise 25.1
	
	Adapt 'getvarvalue' (Listing 25.1) to work with different coroutines
(like the functions from the debug library.
]]

function retrieve_as_local (name, level, looking_for_env,  co)
	level = (level or 1) + 1
	
	for i = 1, math.huge do
		local n, v
		
		if co then
			n, v = debug.getlocal(co, 1, i) -- on a different stack, so const. depth of 1
		else
			n, v = debug.getlocal(level, i)
		end
		
		if not n then return end
		
		if n == name then
			return "local", v
		end
	end
	
	-- Upvalue _ENV isn't present
	if looking_for_env then return end
end

function retrieve_as_upvalue (name, level, looking_for_env, co)
	level = (level or 1) + 1
	
	local func
	
	if co then
		func = debug.getinfo(co, 1).func
	else
		func = debug.getinfo(level, "f").func
	end
	
	for i = 1, math.huge do
		local n, v = debug.getupvalue(func, i)
		if not n then return end
		
		if n == name then
			return "upvalue", v 
		end
	end
	
	-- Upvalue _ENV isn't present
	if looking_for_env then return end
end


-- Note that globals don't belong to functions or coroutines,
-- hence we use no such parameter for the function here.
function retrieve_as_global (name, level)
	level = (level or 1) + 1
	
	local _, env = retrieve_as_local("_ENV", level, true)
	local flag = env and "_ENV was local"
	
	if not env then
		_, env = retrieve_as_upvalue("_ENV", level, true)
		flag = "_ENV was an upvalue"
	end
	
	--print(flag) -- debug code paths
	
	if env then
		return "global", env[name]
	else
		return
	end
end

-- Note that with a 'co' argument, the 'level' parameter won't get used.
function getvarvalue (name, level, looking_for_env, co)
	level = (level or 1) + 1
	
	local tag, value = retrieve_as_local(name, level, looking_for_env, co)
	if tag then return tag, value end
	
	tag, value = retrieve_as_upvalue(name, level, looking_for_env, co)
	if tag then return tag, value end
	
	tag, value = retrieve_as_global(name, level)
	if tag then return tag, value end
	
	return nil
end


A = 42
do
	local _ENV = {_G = _G}
	A = 55
	local print, RL, RG, GV = 
		_G.print, _G.retrieve_as_local, _G.retrieve_as_global, _G.getvarvalue
	print(RL("_ENV", 1, true))
	print("Value of 'A' with localized _ENV:", RG("A"))
	print("Value of 'A' with localized _ENV via 'getvarvalue:", GV("A"))
	print("Value of 'A' by inspection:", A)
end

print("Value of 'A' with old _ENV:", retrieve_as_global("A"))
print("Value of 'A' with old _ENV via 'getvarvalue':", getvarvalue("A"))
print("Value of 'A' by inspection:", A)

local x = 4

B = 12
print("Value of 'x':", getvarvalue("x"))
print("Value of 'B':", getvarvalue("B"))

local b = 0
function foo ()
	local q = b
	print("Value of suspected upvalue 'b':", getvarvalue("b"))
end

foo()

local q = 11
local co = coroutine.create(function ()
	local x = 333
	local y = 3 + q
	print(A + x + y)
	coroutine.yield()
end)

coroutine.resume(co)

print("local x in co should be 333:", getvarvalue("x", 1, false, co))
print("upvalue q in co should be 11:", getvarvalue("q", 1, false, co))

print(); print()
print("NOW COME THE OLD SET OF TESTS")
print(); print()

do
	local _ENV = {_G = _G}
	A = 55
	local print, getvarvalue = _G.print, _G.getvarvalue
	print(getvarvalue("_ENV", 1, true))
	print("Value of 'A' with localized _ENV:", getvarvalue("A"))
	print("Value of 'A' by inspection:", A)
	print(getvarvalue("x"))
end

print("Value of 'A' with old _ENV:", getvarvalue("A", 0))
print("Value of 'A' by inspection:", A)

local GV, P = getvarvalue, print
function quux () P("Calling 'quux':"); P(GV("_ENV", 1, true)) end
quux()