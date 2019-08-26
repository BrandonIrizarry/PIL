--[[
	I thought this might've been a good idea, but I'll scratch this,
since it makes everything unnecessarily complicated (mixing the 'locals'/'upvalues'
approach with direct calls to debug.setlocal and debug.setupvalue.
]]

local locals, upvalues = table.unpack(require "var_it")

local function setlocal (co, level, varname, varvalue)
	for idx, name in locals(co, co and level or level + 1) do
		if name == varname then
			if co then
				return debug.setlocal(co, level, idx, varvalue)
			end
			
			return debug.setlocal(level + 1, idx, varvalue)
		end
	end
end

local function setupvalue (co, level, varname, varvalue)
	for idx, name in upvalues(co, co and level or level + 1) do
		if name == varname then
			return debug.setupvalue(
--[[
	local func
	
	if co then
		func = debug.getinfo(co, level, "f").func
	else
		func = debug.getinfo(level + 1, "f").func
	end
	
	for i = 1, math.huge do
		local name = debug.getupvalue(func, i)
		if not name then return end
		if name == varname then
			return debug.setupvalue(func, i, varvalue)
		end
	end
	]]
end

return {setlocal, setupvalue}