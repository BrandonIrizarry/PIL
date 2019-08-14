--[[
	Iterators to retrieve local and non-local variables (upvalues).
	
	Example usage:
	
	for idx, name, value in locals() do
		print(idx, name, value)
	end
	
	For a regular function, this will iterate over the locals/upvalues visible from
the scope where it's called; for a coroutine, over the locals/upvalues visible
from the scope where this last yielded.
	See the test file for a demonstration.
]]

local M = {}

function M.locals (arg)
	return function (arg, idx)
		idx = idx + 1
		local name, value
		
		if type(arg) == "thread" then
			name, value = debug.getlocal(arg, 1, idx)
		elseif math.type(arg) == "integer" then
			name, value = debug.getlocal(arg + 1, idx)
		else
			error("Invalid arg for 'locals' iterator", 2)
		end
			
		if not name then return nil end
		return idx, name, value
	end, arg, 0
end

function M.upvalues (arg)
	return function (arg, idx)
		idx = idx + 1		
		local func
		
		if type(arg) == "thread" then
			func = debug.getinfo(arg, 1, "f").func
		elseif math.type(arg) == "integer" then
			func = debug.getinfo(arg + 1, "f").func
		else
			error("Invalid arg for 'upvalues' iterator", 2)
		end

		local name, value = debug.getupvalue(func, idx)
		if not name then return nil end	
		
		return idx, name, value
	end, arg, 0
end

return M