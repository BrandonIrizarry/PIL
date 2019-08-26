--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.
]]

local locals, upvalues = table.unpack(require "modules.var_it")

local env

local function varvalue_table (co, level)
	if co == nil then
		level = level + 1
	end
	
	local vt = {}
	vt.locals = {}
	vt.upvalues = {}
		
	for _, name, value in locals(co, level) do
		vt.locals[name] = value
		
		if name == "_ENV" then
			env = value
		end
	end
	
	for _, name, value in upvalues(co, level) do
		vt.upvalues[name] = value
		
		if name == "_ENV" then
			env = value
		end
	end
		
	vt.globals = setmetatable({}, {__index = function (_, varname)
	
		-- Don't trigger "strict" errors; return nil instead.
		local status, value = pcall(function () return env[varname] end)
		if not status then return nil end
		
		return value
	end})
		
	return vt
end

return varvalue_table
