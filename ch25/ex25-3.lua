--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.
]]

local vt = require "modules.var_it"
local locals = vt.locals
local upvalues = vt.upvalues

return function (arg)
	arg = arg or 2
	
	if (type(arg) ~= "thread") and (math.type(arg) ~= "integer") then
		error ("Invalid type for table-version of getvarvalue", 2)
	end
	
	
	-- Use 'vt.env', instead.
	-- local env -- for finding _ENV
	
	local vt = {}
	vt.locals = {}
	vt.upvalues = {}
	
	
	for _, name, value in locals(arg) do
		vt.locals[name] = value
		
		if name == "_ENV" and not vt.env then
			vt.env = value
		end
	end
	
	for _, name, value in upvalues(arg) do
		vt.upvalues[name] = value
		
		if (name == "_ENV") and not vt.env then
			vt.env = value
		end
	end
	
	-- In practice, _ENV is huge (all the standard Lua stuff),	
	-- so this makes sense.
	vt.globals = setmetatable({}, {__index = function (_, varname)
		-- Don't trigger "strict" errors; just return nil, as before.
		local status, value = pcall(function () return vt.env[varname] end)
		if not status then return nil end
		
		return value
	end})
		
	return vt
end
