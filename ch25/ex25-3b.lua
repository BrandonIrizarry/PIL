--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.
]]

local locals, upvalues = table.unpack(require "modules.var_it")

local env

local function varvalue_table (level, co)
	if co == nil then
		level = level + 1
	end
	
	local vt = {}
	
	for _, name, value in upvalues(level, co) do
		vt[name] = value
		
		if name == "_ENV" then
			env = value
		end
	end
	
	for _, name, value in locals(level, co) do
		vt[name] = value
		
		if name == "_ENV" then
			env = value
		end
	end
	
		
	return setmetatable(vt, {
		__index = function (_, varname)
			return env and env[varname] or nil
		end
	})
end

return varvalue_table
