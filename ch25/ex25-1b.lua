--[[
	Exercise 25.1
	
	Adapt 'getvarvalue' (Listing 25.1) to work with different coroutines
(like the functions from the debug library.)
]]

local locals, upvalues = table.unpack(require "modules.var_it")
local env

local function getvarvalue (varname, level, co)
	if co == nil then
		level = level + 1
	end
	
	local foundtype, foundvalue
	
	for _, name, value in locals(co, level) do
		if name == varname then
			foundtype, foundvalue = "local", value
			
		if name == "_ENV" then
			env = value
		end
	end
	
	for _, name, value in upvalues(co, level) do
		if name == varname then
			foundtype, foundvalue = "upvalue", value
			
		if name == "_ENV" then
			env = value
		end
	end
	
	if foundtype then
		return foundtype, foundvalue
	else
		return "global", env[varname]
	end
end

return getvarvalue

