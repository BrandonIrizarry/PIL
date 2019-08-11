--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.

	Our function is called 't_all'.  Check out the _it files for iterators that
make finding locals and upvalues easier.
	'flevel' points the iterator to start scanning in the proper scope, 
but the 'level' control variable (here omitted using '_') still starts
with the level as seen by Lua (e.g., 2 instead of 1).
]]

local locals = require "modules.local_it"
local upvalues = require "modules.upvalue_it"

return function (co, flevel)
	local flevel = (co and 0) or flevel
	local env -- for finding the _ENV to use with globals metatable
	
	local result = {}
	result.locals = {}
	result.upvalues = {}
	
	
	for _, ltable in locals(co, flevel) do
		table.insert(result.locals, ltable)
		
		for name, value in pairs(ltable) do
			if (name == "_ENV") and not env then
				env = value
			end
		end
	end
	
	for _, utable in upvalues(co, flevel) do
		table.insert(result.upvalues, utable)
		
		for name, value in pairs(utable) do
			if (name == "_ENV") and not env then
				env = value
			end
		end
	end
	
	result.globals = setmetatable({}, {__index = env})
	
	return result
end