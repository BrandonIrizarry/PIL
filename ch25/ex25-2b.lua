--[[
	Exercise 25.2
	
	Write a function 'setvarvalue' similar to 'getvarvalue'
(Listing 25.1).
]]

local function setvarvalue (varname, varvalue, level, co)
	level = level or 1
	
	local isenv = 0
	local search_name = varname
	local vartype, varidx, func
	local env -- make indexing _ENV easier when setting globals
	
	while isenv < 2 do
		--print(isenv)
		--print"try local variables"
		for i = 1, math.huge do
			local name, value
			
			if co then
				name, value = debug.getlocal(co, level, i)
			else
				name, value = debug.getlocal(level + 1, i)
			end
			
			if not name then break end
			if name == "_ENV" then env = value end
			
			if name == search_name then
				vartype, varidx = "local", i
			end
		end
		
		--print"try non-local variables"
		func = co and debug.getinfo(co, level, "f").func or debug.getinfo(level + 1, "f").func
		
		for i = 1, math.huge do
			local name, value = debug.getupvalue(func, i)
			if not name then break end
			if name == "_ENV" then env = value end
			if name == search_name then 
				vartype, varidx = "upvalue", i
			end
		end
		
		if vartype then break end 
		search_name = "_ENV"
		isenv = isenv + 1
	end

	if isenv == 0 then
		if vartype == "local" then
			if co then
				return debug.setlocal(co, level, varidx, varvalue)
			end
			
			return debug.setlocal(level + 1, varidx, varvalue)
		elseif vartype == "upvalue" then
			return debug.setupvalue(func, varidx, varvalue)
		else
			error(string.format("Invalid type '%s' on first spin", vartype))
		end
	elseif isenv == 1 then -- env should be the governing _ENV
		local status, result = pcall(function () env[varname] = varvalue end)
		if not status then
			return string.format("'%s' not declared", varname)
		end
		
		return varname
	elseif isenv == 2 then
		return "no env variable"
	else
		error("invalid value for 'isenv'")
	end
end

return setvarvalue