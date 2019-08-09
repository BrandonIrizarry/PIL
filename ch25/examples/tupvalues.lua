local M = {}

local function next_upvalue (co, level)
	level  = level + 1
	
	local valid 
	
	if co then
		valid = debug.getinfo(co, level, "f")
	else
		valid = debug.getinfo(level + 1, "f")
	end
	
	if valid == nil then return end
	
	local func = valid.func
	local upvalues = {}
	
	for idx = 1, math.huge do
		local name, value = debug.getupvalue(func, idx)
		
		if not name then break end		
		upvalues[idx] = {}
		upvalues[idx].name = name
		upvalues[idx].value = value
	end
	
	return level, upvalues
end

-- 'flevel' is an offset for functions that call this iterator-constructor,
-- to inspect a regular function's variables (from the inside).
local function upvalues (co, flevel)
	return next_upvalue, co, flevel or 0
end

-- The main function - return a table of all the upvalues,
-- according to a certain format.
local function tupvalues (co)
    local flevel = (co and 0) or 1  
	local tu = {}
	
	for level, utable in upvalues(co, flevel) do
		tu[level - flevel] = utable
	end
	
	return tu
end

return tupvalues