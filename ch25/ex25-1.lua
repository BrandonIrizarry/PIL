--[[
	Exercise 25.1
	
	Adapt 'getvarvalue' (Listing 25.1) to work with different coroutines
(like the functions from the debug library.
]]

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
	
		-- try non-local variables
		local func = co and debug.getinfo(co, level, "f").func or debug.getinfo(level + 1, "f").func
		
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
		
		return "error", string.format("'%s' not declared", varname)
	elseif isenv == 2 then
		return "error", "no env variable"
	else
		error("invalid value for 'isenv'")
	end
end

a = 5
c = nil -- 'nil', but the explicit declaration makes this test fall through ('b' will fail, though)

local uv = 15
local vw = 21

function message (x)
	a = a - 1
	local x = vw
	coroutine.yield(x)
end


function test_instance(varname, tshould, vshould, level, co)
	if not co then
		level = level + 1
	end
	
	local vartype, varvalue = getvarvalue(varname, level, co)
	print(vartype, varvalue)
end

function print_many ()
	a = a - 1
	local x = uv 
	local x = vw
	test_instance("x", "local", 21, 1)
	coroutine.yield()
	message()
end

co = coroutine.create(print_many)

coroutine.resume(co)


test_instance("x", "local", 21, 1, co)
test_instance("a", "global", 4, 1, co)

coroutine.resume(co)
print(getvarvalue("x", 1, co))
print(getvarvalue("x", 2, co))
print(getvarvalue("uv", 2, co))
print(getvarvalue("vw", 1, co))
--print(getvarvalue("a", 1))
test_instance("a", "global", 3, 1)
--print(getvarvalue("b", 1)) -- should say, "not declared"
test_instance("b", "error", "'b' not declared", 1)
print(getvarvalue("c", 1))
print(getvarvalue("a", 1, co))

print(getvarvalue("a", 2, co))

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

return getvarvalue

