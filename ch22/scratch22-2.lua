
local function get_upvalue (fn, search_name)
	for idx = 1, math.huge do
		local name, val = debug.getupvalue(fn, idx)
		if not name then break end
		if name == search_name then
			return idx, val
		end
	end
end

local function see_all_upvalues (fn)
	for idx = 1, math.huge do
		local name, value = debug.getupvalue(fn, idx)
		if not name then break end
		print(name, value)
	end
end

local foo

do
	local e = _ENV -- bingo - this is it.
	
	function foo ()
		e.print(e.X) 
	end
end

--see_all_upvalues(setup)
--local _, env_value = get_upvalue(foo, "_ENV")
--print(env_value == _ENV)

_ENV.X = 13
_ENV.print("X, under conventional _ENV, is: ", _ENV.X)
_ENV = nil
foo()
--print(get_upvalue(foo, "_ENV"))
--see_all_upvalues(foo)
--foo()
--X = 0
--]]