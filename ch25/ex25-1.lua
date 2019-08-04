--[[
	Exercise 25.1
	
	Adapt 'getvarvalue' (Listing 25.1) to work with different coroutines
(like the functions from the debug library.
]]

function getvarvalue (name, level, isenv, co)
	local value
	local found = false
	
	level = (level or 1) + 1
	
	-- try local variables
	for i = 1, math.huge do
		local n, v = co and debug.getlocal(co, 1, i) or debug.getlocal(level, i)
		if not n then break end
		if n == name then
			print(n)
			value = v
			found = true
		end
	end
	
	if found then return "local", value end
	
	-- try non-local variables
	local func = co and debug.getinfo(co, 1, "f").func or debug.getinfo(level, "f").func
	
	for i = 1, math.huge do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return "upvalue", v end
	end
	
	if isenv then return false end -- avoid loop
	
	-- not found; get value from the environment
	local _, env = getvarvalue("_ENV", level, true, co)
	if env then
		return "global", env[name]
	else	-- no _ENV variable
		return "noenv"
	end
end


function printer (input)
	local message = "Current number: "
	print(message..input)
end


function print_many ()
	local x = 10
	
	for i = 1, 5 do
		printer(i)
		coroutine.yield(i)
	end
end

co = coroutine.create(print_many)

coroutine.resume(co)
print(debug.getlocal(co, 1, 1))
print(getvarvalue("x", 1, false, co))