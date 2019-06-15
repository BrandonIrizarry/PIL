--[[
	Exercise 25.2
	
	Write a function 'setvarvalue' similar to 'getvarvalue' (Listing 25.1)
]]


-- Used for ordinary functions (i.e. not for coroutines.)
function find_local (search_name, level, value)
	for i = 1, math.huge do
		local name, value = debug.getlocal(level, i)
		
		if not name then return end
		if name == search_name then return i end
	end
end

function find_upvalue (search_name, level, looking_for_env)
	local func = debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local name, value = debug.getupvalue(func, i)
		
		if not name then return end
		if name == search_name then return i end
	end
	
	if looking_for_env then return end
end

function set_global (search_name, level)
	local _, env_idx = find_upvalue("_ENV", level, true)
end


-- Test 'find_local'
local x = 9
local y = 4

print("local x has index: ", find_local("x", 2))
print("local y has index: ", find_local("y", 2))
		
-- Test 'find_upvalue'

function foo ()
	print("_ENV in 'foo':", find_upvalue("_ENV", 1))
end

print("_ENV in the wild:", find_upvalue("_ENV", 1))
foo()

--[[
	The whole act of finding a global variable consists of:
	1. Seeing if _ENV exists as an upvalue where you're searching.
	2. Simply returning _ENV[search_name] at that point.
]]
		