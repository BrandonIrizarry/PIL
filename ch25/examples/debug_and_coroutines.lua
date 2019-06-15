
local A = 11

local co = coroutine.create(function (a)
	local x = 10 + A -- 'A' is an upvalue
	coroutine.yield() -- global
	local y = 15
	coroutine.yield() -- global
end)

--coroutine.resume(co)

-- Notice that you have to actually run the coroutine for this to work
-- (get up to the definition of x)
--print(debug.getupvalue(co, 1))
--[[
print(debug.getlocal(co, 1, 3))

coroutine.resume(co)

print(debug.getlocal(co, 1, 3))

for k,v in pairs(debug.getinfo(co, 1)) do
	print(k,v)
end
--]]

coroutine.resume(co)

-- This is how you get a coroutine's body.
local f = debug.getinfo(co, 1).func

function see_upvalues (fn)
	print("--NEW FUNCTION")
	
	for i = 1, math.huge do
		local name, value = debug.getupvalue(fn, i)
		if not name then break end
		print(name, value)
	end
end

see_upvalues(f)

coroutine.resume(co)

see_upvalues(f)

local bro = coroutine.create(function ()
	print(42)
end)

coroutine.resume(bro)

local g = debug.getinfo(bro,1).func

debug.getupvalue(g, 1)
