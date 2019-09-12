--[[
	Exercise 25.2
	
	Write a function 'setvarvalue' similar to 'getvarvalue'
(Listing 25.1).
]]

local locals, upvalues = table.unpack(require "modules.var_it")
local env

local function setvarvalue (varname, varvalue, level, co)
	if co == nil then
		level = level + 1
	end
	
	--local LEVEL = (co and level) or level + 1
	
	local found
	
	for idx, name, value in locals(level, co) do
		if name == varname then
			if co then
				debug.setlocal(co, level, idx, varvalue)
			else
				debug.setlocal(level, idx, varvalue)
			end
			
			found = true
		end
		
		if name == "_ENV" then
			env = value
		end
	end
	
	for idx, name, value, func in upvalues(level, co) do
		if name == varname then
			debug.setupvalue(func, idx, varvalue)
			found = true
		end
		
		if name == "_ENV" then
			env = value
		end
		
	end
	
	if found == nil then
		env[varname] = varvalue
	end
end

return setvarvalue