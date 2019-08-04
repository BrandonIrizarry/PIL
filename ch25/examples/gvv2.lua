
function print_upvalues (f)
	for i = 1, math.huge do
		local name, value = debug.getupvalue(f, i)
		if not name then break end
		print(name, value)
	end
end


-- tbc - the original 'getvarvalue' finds b set to 14, but this doesn't.
-- Yet I must find what is different about the two.
function get_as_global (var_name, level)
	--level = (level or 1) + 1
		
	local func = debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local name, value = debug.getupvalue(func, i)
		if not name then break end -- stop when there are no more upvalues to search.
		
		if name == "_ENV" then
			--[[
			for k, v in pairs(value) do
				print("inspecting _ENV: ", k,v)
			end
			--]]
			local var_value = value[var_name]
			if var_value then
				return "global", var_value
			else
				return "not found in _ENV"
			end
		end
	end
	
	return "no _ENV here"
end

function sneak_in_the_global ()
	haha = "gotcha"
end

--[[
a = 4
sneak_in_the_global()
print(get_as_global("a"))
print(get_as_global("haha"))
print(get_as_global("lmao_i_was_never_declared"))
--]]

-- try non-local variables
function get_as_upvalue(name,level)
	--level = (level or 2) + 1
	local func = debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local n, v  = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return "upvalue", n, v end
	end
	
	return "no such upvalue"
end

	
	
local print = print
--local get_as_global = get_as_global
local get_as_upvalue = get_as_upvalue
function foo (_ENV, a)
	print(a + b)
	print("This should be your answer: ", _ENV.b)
	--print(get_as_upvalue("_ENV"))
	local _type, name, value = get_as_upvalue("_ENV", 4)
	print(value.b)
end

foo({b = 14}, 12)

