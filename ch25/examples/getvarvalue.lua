function getvarvalue (name, level, isenv)
	local value
	local found = false
	
	level = (level or 1) + 1
	
	-- try local variables
	for i = 1, math.huge do
		local n, v = debug.getlocal(level, i)
		if not n then break end
		
		if n == name then
			value = v
			found = true
		end
	end
	
	if found then return "local", value end
	
	-- try non-local variables
	local func = debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local n, v  = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return "upvalue", v end
	end
	
	if isenv then return end -- avoid loop
	
	-- not found; get value from the environment
	local _, env = getvarvalue("_ENV", level, true)
	
	if env then
		return "global", env[name]
	else
		return "An _ENV table is not present in the surrounding closure."
	end
end

-- Force 'foo' to not have an upvalue _ENV, so we can see 
-- 'getvarvalue' output that an _ENV hasn't been found ("noenv").
local print = print
local getvarvalue = getvarvalue

function foo () print(getvarvalue("a")) end

-- See if _ENV shows up as an upvalue.
print(debug.getupvalue(foo, 1))

foo()


Global_Value = 42

print(getvarvalue("Global_Value"))

--[[
	From the look of it, the "noenv" to stop the loop wasn't needed, since returning only 
one value from the recursive call (line 32) will set 'env' to nil anyway.
]]