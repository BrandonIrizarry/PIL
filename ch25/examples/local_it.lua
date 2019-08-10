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
		name = (name == "(*temporary)") and idx or name
		locals[name] = value
	end
	
	return level, locals
end

-- 'flevel' is an offset for functions that call 'locals' to 
-- inspect a regular function's variables (from the inside).
local function locals (co, flevel)
	return next_local, co, flevel or 0
end

return locals