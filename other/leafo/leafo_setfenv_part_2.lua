--[[
	Upvalues can be shared across many functions.
]]

local number = 15

local function get_upvalue(fn, search_name)
  local idx = 1
  while true do
    local name, val = debug.getupvalue(fn, idx)
    if not name then break end
    if name == search_name then
      return idx, val
    end
    idx = idx + 1
  end
end

-- Has upvalue 'number'
local function lucky ()
	print("your lucky number: " .. number)
end

-- Has the same number upvalue 'number'
local function lucky2()
	print("you other number: " .. number)
end

-- Setting it for 'lucky', but...
debug.setupvalue(lucky, get_upvalue(lucky, "number"), 22)

lucky2() -- changes for lucky2!

local new_env = {
	print = function ()
		print("no lucky number for you!")
	end
}

-- _ENV is the nth upvalue of 'lucky' --> change it to the first (1) 
-- upvalue of the anonymous function, which is the new environment.
debug.upvaluejoin(lucky, get_upvalue(lucky, "_ENV"), function() return new_env end, 1)

lucky()


local function setfenv (fn, env)
	for idx = 1, math.huge do
		local name = debug.getupvalue(fn, idx)
		
		if name == "_ENV" then
			debug.upvaluejoin(fn, idx, function () return env end, 1)
			break
		elseif not name then -- we've gone through all the upvalues
			break
		end
	end
	
	return fn
end
			

-- It doesn't look like you can bestow an _ENV on something that doesn't have one.
local function setfenv (fn, env)
	local idx = 1
	
	repeat
		local name = debug.getupvalue(fn, idx)
		if name == "_ENV" then
			debug.upvaluejoin(fn, idx, function() return env end, 1)
			break
		end
		idx = idx + 1
	until name == nil
	
	return fn
end

local function getfenv (fn)
	local idx = 1
	
	repeat
		local name, val = debug.getupvalue(fn, idx)
		if name == "_ENV" then
			return val
		end
		idx = idx + 1
	until name == nil
end
