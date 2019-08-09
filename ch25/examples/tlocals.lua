--[[
	NB: We were trying the following, to set 'valid':
	
	local valid = (co and debug.getinfo(co, level)) or debug.getinfo(level + 1)

However, when debug.getinfo(co, level) is nil yet co is not nil, valid will be fitted with
debug.getinfo(level + 1), which was meant for a non-coroutine inspection and will 
therefore naturally result in an error.
]]

local function next_local (co, level)
	level  = level + 1
	
	local valid 
	
	if co then
		valid = debug.getinfo(co, level)
	else
		valid = debug.getinfo(level + 1)
	end
	
	if valid == nil then return end
	local locals = {}
	
	for idx = 1, math.huge do
		local name, value 
		if co then
			name, value = debug.getlocal(co, level, idx)
		else
			name, value = debug.getlocal(level + 1, idx)
		end
		
		if not name then break end
		locals[idx] = {}
		locals[idx].name = name
		locals[idx].value = value
	end
	
	return level, locals
end

-- 'flevel' is an offset for functions that call 'locals' to 
-- inspect a regular function's variables (from the inside).
local function locals (co, flevel)
	return next_local, co, flevel or 0
end

-- The main function - return a table of all the locals,
-- according to a certain format.
local function tlocals (co)
    local flevel = (co and 0) or 1  
	local tl = {}
	
	for level, ltable in locals(co, flevel) do
		tl[level - flevel] = ltable
	end
	
	return tl
end

return tlocals