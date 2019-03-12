

local number = 15
local function lucky ()
	print("your lucky number: " .. number)
end

local function lucky2 ()
	print("your other number: " .. number)
end

local function get_upvalue (fn, search_name)
	for idx = 1, math.huge do
		local name, val = debug.getupvalue(fn, idx)
		if not name then break end
		if name == search_name then
			return idx, val
		end
	end
end

local new_env = {
	print = function ()
		print("no lucky number for you!")
	end
}

debug.upvaluejoin(lucky, get_upvalue(lucky, "_ENV"),
	function() return new_env end, 1)

lucky()

local function _setfenv(fn, env)
	for i = 1, math.huge do
		local name = debug.getupvalue(fn, i)
		if name == "_ENV" then
			debug.upvaluejoin(
				fn,
				i,
				function () return env end,
				1)
			break
		elseif not name then
			break
		end
	end
	
	return fn
end

local function _getfenv (fn)
	for i = 1, math.huge do
		local name, value = debug.getupvalue(fn, i)
		if name == "_ENV" then
			return value
		elseif not name then
			break
		end
	end
end
