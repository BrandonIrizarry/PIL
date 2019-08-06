--[[
	This is an alternate way to write getvarvalue (and also solve ex25-1).
Hopefully, this template will serve to write ex25-2, 'setvarvalue'.
]]

-- This function will return "local"/"upvalue", plus the index.
function get_var_type (varname, level, isenv, co)
	local diff = (isenv and 3) or 2
	level = (level or 1) + 1
	
	for idx = 1, math.huge do
		local lname = (co and debug.getlocal(co, level - diff, idx)) or debug.getlocal(level, idx)
		if not lname then break end
		
		if lname == varname then
			return "local", idx
		end
	end

	local func = (co and debug.getinfo(co, level - diff, "f").func) or debug.getinfo(level, "f").func
	
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
	level = (level or 1) + 1
	
	local vartype, idx, func = get_var_type(varname, level, isenv, co)
	
	if vartype == "local" then
		local name, value
		if co then
			name, value = debug.getlocal(co, level - 1, idx)
		else
			name, value = debug.getlocal(level, idx)
		end
		return vartype, value
	elseif vartype == "upvalue" then
		local name, value = debug.getupvalue(func, idx)
		return vartype, value
	elseif vartype == "global" and (not isenv) then
		local _, env = getvarvalue("_ENV", level, true, co)
		if env then
			-- "strict" won't let us access an undeclared 'name' in _ENV, so...
			-- NB: This works when "strict" isn't set, too.
			local status, result = pcall(function () return env[varname] end)
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


a = 5
c = nil -- 'nil', but the explicit declaration makes this test fall through ('b' will fail, though)

local uv = 15
local vw = 21

function message (x)
	a = a - 1
	local x = vw
	local y = 4
	coroutine.yield(x)
end

function print_many ()
	a = a - 1
	local x = uv 
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
print(getvarvalue("b", 1, false))
print(getvarvalue("c", 1, false))
print(getvarvalue("a", 1, false, co))

print(getvarvalue("a", 2, false, co))

print("\nAnother set of tests!")
local print = print
local getvarvalue = getvarvalue
function foo (_ENV, a)
	print(a + b)
	print("This should be your answer: ", _ENV.b)
	print(getvarvalue("b"))
end  -- _ENV is local, so to find such an _ENV, you need to scan for local variables.


foo({b = 14}, 12)