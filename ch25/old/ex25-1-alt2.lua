function getlocal (level, idx, co)
	if co then
		return debug.getlocal(co, level, idx)
	end
	
	return debug.getlocal(level + 1, idx)
end

function getfunc (level, co)
	if co then
		return debug.getinfo(co, level, "f").func
	end
	
	return debug.getinfo(level + 1, "f").func
end


function get_var_type (varname, level, co)
	level = level and (co and level or level + 1) or 1
	
	for idx = 1, math.huge do
		local lname = getlocal(level, idx, co)
		if not lname then break end
		
		if lname == varname then
			return "local", idx
		end
	end

	local func = getfunc(level, co)
	
	for idx = 1, math.huge do
		local uname = debug.getupvalue(func, idx)
		if not uname then break end
		
		if uname == varname then 
			return "upvalue", idx, func
		end
	end
	
	return "global"
end

function getvarvalue (varname, level, isenv, co)
	level = level and (co and level or level + 1) or 1
	
	local vartype, idx, func = get_var_type(varname, level, co)
	
	if vartype == "local" then
		local _, value = getlocal(level, idx, co)
		return vartype, value
	elseif vartype == "upvalue" then
		local _, value = debug.getupvalue(getfunc(level, co), idx)
		return vartype, value
	elseif vartype == "global" and (not isenv) then
		local _, env = getvarvalue("_ENV", level, true, co)
		if env then
			local status, result = pcall(function () return env[varname] end) -- see "strict.lua"
			if status then 
				return "global", env[varname]
			else
				return string.format("'%s' not declared", varname)
			end
		else
			return "no env variable"
		end
	else
		error("Wrong value for 'vartype'")
	end
end

--[=[
function cget_var_type (co, varname, level)
	
	for idx = 1, math.huge do
		local lname = debug.getlocal(co, level, idx))
		
		if not lname then break end
		
		if lname == varname then
			return "local", idx
		end
	end

	local func = debug.getinfo(co, level, "f").func)
	
	for idx = 1, math.huge do
		local uname = debug.getupvalue(func, idx)
		if not uname then break end
		
		if uname == varname then 
			return "upvalue", idx, func
		end
	end
	
	return "global"
end
--[=[
function cgetvarvalue (co, varname, level, isenv)
	local vartype, idx, func = cget_var_type(co, varname, level, isenv)
	
	if vartype == "local" then
		local _, value = debug.getlocal(co, level, idx)
		return vartype, value
	elseif vartype == "upvalue" then
		local _, value = debug.getupvalue(func, idx)
		return vartype, value
	elseif vartype == "global" and (not isenv) then
		local _, env = cgetvarvalue(co, "_ENV", level, true)
		if env then
			local status, result = pcall(function () return env[varname] end) -- see "strict.lua"
			if status then 
				return "global", env[varname]
			else
				return string.format("'%s' not declared", varname)
			end
		else
			return "no env variable"
		end
	else
		error("Wrong value for 'vartype'")
	end
end
--]=]

a = 5
c = nil -- 'nil', but the explicit declaration makes this test fall through ('b' will fail, though)

local uv = 15
local vw = 21

function message (x)
	a = a - 1
	local x = vw
	coroutine.yield(x)
end

function print_many ()
	a = a - 1
	local x = uv 
	local x = vw
	coroutine.yield()
	message()
end

co = coroutine.create(print_many)

coroutine.resume(co)

print(getvarvalue("x", 1, false, co))
print(getvarvalue("a", 1, false, co))

coroutine.resume(co)
print(getvarvalue("x", 1, false, co))
print(getvarvalue("x", 2, false, co))
print(getvarvalue("uv", 2, false, co))
print(getvarvalue("vw", 1, false, co))
print(getvarvalue("a", 1, false))
print(getvarvalue("b", 1, false)) -- should say, "not declared"
print(getvarvalue("c", 1, false))
print(getvarvalue("a", 1, false, co))

print(getvarvalue("a", 2, false, co))

--[[
t = {x = 12}
print(getvarvalue(x))
]]

print("\nAnother set of tests!")
local print = print
local getvarvalue = getvarvalue
function foo (_ENV, a)
	print(a + b)
	print("This should be your answer: ", _ENV.b)
	print(getvarvalue("b"))
end  -- _ENV is local, so to find such an _ENV, you need to scan for local variables.


foo({b = 14}, 12)

print("\nAnother set of tests!")
function bottom ()
	--print(get_var_type("x", 2))
	coroutine.yield()
end

function test ()
	local x = 0

	bottom()
	
	print(debug.getlocal(1,1))
end

co = coroutine.create(test)
coroutine.resume(co)

debug.setlocal(co, 2, 1, 1)

coroutine.resume(co)


