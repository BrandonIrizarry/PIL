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
	arg = arg or 1
	
	if (type(arg) ~= "thread") and (math.type(arg) ~= "integer") then
		error ("Invalid type for table-version of getvarvalue", 2)
	end
	
	
	local env -- for finding _ENV
	
	local vt = {}
	vt.locals = {}
	vt.upvalues = {}
	
	
	for idx, name, value in locals(arg) do
		vt.locals[name] = {value = value, index = idx}
		
		if name == "_ENV" and not env then
			env = value
		end
	end
	
	for idx, name, value in upvalues(arg) do
		vt.upvalues[name] = {value = value, index = idx}
		
		if (name == "_ENV") and not env then
			env = value
		end
	end
	
	-- In practice, _ENV is huge (all the standard Lua stuff),	
	-- so this makes sense.
	vt.globals = setmetatable({}, {__index = function (_, varname)
		-- Don't use "strict" in this case, since, presumably, actual
		-- references in the function body itself will trigger it.
		local status, value = pcall(function () return env[varname] end)
		if not status then return nil end
		
		return value
	end})
	
	-- For debugging (could this otherwise be useful?)
	
	local mt = {
		__pairs = function (cl) -- must accept "client" for this to work!
			return function (cl, name)
				local name, info = next(cl, name)
				if not name then return nil end
			
				return name, info.value, info.index
			end, cl, nil
		end
	}
	
	setmetatable(vt.locals, mt)
	setmetatable(vt.upvalues, mt)
	
	return vt
end
