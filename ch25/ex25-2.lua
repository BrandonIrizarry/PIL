--[[
	Exercise 25.2
	
	Write a function 'setvarvalue' similar to 'getvarvalue'
(Listing 25.1).

tbc - we can't return directly in the loops, since we must always allow the possibility 
an _ENV search, as we did in ex25-1. we have to set some "star variables", and check on
them after the loop finishes, based on the value of 'isenv' (again, as before).
]]

function setvarvalue (varname, varvalue, level, co)
	level = level or 1
	
	local isenv = 0
	local search_name = varname
	
	while isenv < 2
		-- try local variables
		for i = 1, math.huge do
			local name
			
			if co then
				name = debug.getlocal(co, level, i)
				if not name then break
				if name == search_name then
					debug.setlocal(co, level, i, varvalue)
					return
				end
			else
				name = debug.getlocal(level + 1, i)
				if not name then break
				if name == search_name then
					debug.setlocal(level, i, varvalue)
					return
				end
			end
		end
		
		-- try non-local variables
		local func = co and debug.getinfo(co, level, "f").func or debug.getinfo(level + 1, "f").func
		
		for i = 1, math.huge do
			local name = debug.getupvalue(func, i)
			if not name then break end
			if name == search_name then 
				debug.setupvalue(func, i, varvalue)
				return
			end
		end
		
		search_name = "_ENV"
		isenv = isenv + 1
	end

	
end


--[[
function getvarvalue (varname, level, co)
	level = level or 1
	
	local vartype, varvalue
	local isenv = 0
	
	local search_name = varname 
	
	
	while isenv < 2 do
		-- try local variables
		for i = 1, math.huge do
			local name, value
			
			if co then
				name, value = debug.getlocal(co, level, i)
			else
				name, value = debug.getlocal(level + 1, i)
			end
			
			if not name then break end
			if name == search_name then
				vartype, varvalue = "local", value 
			end
		end
	
		local func = co and debug.getinfo(co, level, "f").func or debug.getinfo(level + 1, "f").func
		
		-- try non-local variables
		for i = 1, math.huge do
			local name, value = debug.getupvalue(func, i)
			if not name then break end
			if name == search_name then 
				vartype, varvalue = "upvalue", value 
			end
		end
	
		if vartype then break end -- both vartype and varvalue are set
		
		-- not found; get value from the environment
		search_name = "_ENV"
		isenv = isenv + 1
	end
		
	if isenv == 0 then
		return vartype, varvalue
	elseif isenv == 1 then
		local status, result = pcall(function () return varvalue[varname] end)
		
		if status then
			return "global", result
		end
		
		return string.format("'%s' not declared", varname)
	elseif isenv == 2 then
		return "no env variable"
	else
		error("invalid value for 'isenv'")
	end
end
]]