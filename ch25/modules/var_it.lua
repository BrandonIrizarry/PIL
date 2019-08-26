--[[
	Iterators to retrieve local and non-local variables (upvalues).
	
	Example usage:
	
	-- This will print all surrounding locals visible at my level (regular function)
	for idx, name, value in locals(nil, 1) do
		print(idx, name, value)
	end
	
	-- This will print all locals visible at the level _above_ where the coroutine last yielded
	for idx, name, value in locals(co, 2) do
		print(idx, name, value)
	end
	
	See the test file for a demonstration.
]]

local function locals (co, level)
	if not level then
		error("Missing stack level", 2)
	end
	
	return function (state, idx)
		idx = idx + 1
		local name, value
		
		local co = state.co
		local level = state.level
		
		if co then
			name, value = debug.getlocal(co, level, idx)
		else
			name, value = debug.getlocal(level + 1, idx)
		end
		
		if not name then return nil end
		
		return idx, name, value
	end, {co=co, level=level}, 0
end

local function upvalues (co, level)
	if not level then
		error("Missing stack level", 2)
	end

	return function (state, idx)
		idx = idx + 1		
		local func
		
		local co = state.co
		local level = state.level
		
		if co then
			func = debug.getinfo(co, level, "f").func
		else
			func = debug.getinfo(level + 1, "f").func
		end
		
		local name, value = debug.getupvalue(func, idx)
		
		if not name then return nil end	
		
		return idx, name, value
	end, {co=co, level=level}, 0
end

return {locals, upvalues}