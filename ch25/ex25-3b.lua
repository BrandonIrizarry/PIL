--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.
]]

local M = {}

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
	
	return setmetatable(vt, {__index = function (_, name)
		return env and env[name] or nil
	end})
end
		
--[[
local function varvalue_table (level, co)
	if co == nil then
		level = level + 1
	end
	 
	local vt = {}
	local vt.read_locals = {}
	local vt.read_upvalues = {}
	
	for idx, name, value in upvalues(level, co) do
		vt.read_upvalues[name] = {idx, value}
		
		if name == "_ENV" then
			env = value
		end
	end
	
	for _, name, value in locals(level, co) do
		vt.read_locals[name] = {idx, value}
		
		if name == "_ENV" then
			env = value
		end
	end
	
	vt.locals = setmetatable({}, {
		__index = function (_, name)
			return vt.read_locals[name][VALUE]
		end,
		
		__newindex = function (_, name, value)
			local idx = vt.read_locals[name][INDEX] 
			
			if co then
				debug.setlocal(co, level, idx, value)
			else
				debug.setlocal(level + 2, idx, value)
			end
		end,
	})
	
	vt.upvalues = setmetatable({}, {
		__index = function (_, name)
			return vt.read_upvalues[name][VALUE]
		end,
		
		__newindex = function (_, name, value)
			local idx = vt.read_upvalues[name][INDEX]
			
			if co then
				debug.setupvalue(co, level, idx, value)
			else
				debug.setupvalue(level + 2, idx, value)
			end
		end,
	})
		
	vt.globals = setmetatable({}, {__index = function (_, name)
		return env and env[varname] or nil
	end)
	
		
	return setmetatable(vt, {
		__index = function (_, varname)
			return env and env[varname] or nil
		end
	})
end
--]]

return varvalue_table
