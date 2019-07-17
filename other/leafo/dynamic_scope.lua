
local y = math.pi
local z = math.huge

-- This is how I can get the complete listing of local variables
-- across the entire call stack: from where I am, all the way to 
-- the top!
function list_locals ()
	local x = 10
	
	for level = 1, math.huge do
		for idx = 1, math.huge do
			
			if not debug.getinfo(level) then
				return
			else
				local fnd_nm, fnd_vl = debug.getlocal(level, idx)
				if not fnd_nm then break end
				print("level: ", level, fnd_nm, fnd_vl)
			end
		end
	end
end

--[[
function localgen (level)
	--level = level + 1 -- we really want the caller's perspective
	
	if debug.getinfo(level) then
		for idx = 1, math.huge do
			local name, value = debug.getlocal(level, idx)
			if not name then break end
			
			coroutine.yield(name, value)
		end
	end
end

function locals (level)
	return coroutine.wrap(function () localgen(level) end)
end

function test (n)
	local x,y = 1,2
	
	for name, value in locals(3) do
		print(name, value)
	end
end

test()
--]]

function locals (level)
	local function iter (_, idx)
		if debug.getinfo(level) then
			idx = idx + 1
			local name, value = debug.getlocal(level + 1, idx)
			if name then
				return idx, name, value
			end
		end
	end
		
	return iter, nil, 0
end

function all_locals ()
	local function iter (_, level)
		level = level + 1
		if debug.getinfo(level + 1) then
			local level_info = {}
			
			for idx, name, value in locals(level + 1) do
				level_info[idx] = {}
				level_info[idx].name = name
				level_info[idx].value = value
				
			end
			
			return level, level_info
		end
	end
	
	return iter, nil, 0 -- first applicable level for the caller should be 1, not 2.
end
			
	
function test ()
	local x,y = 1,2
	
	for level, level_info in all_locals() do
		print(level)
		for idx, var in ipairs(level_info) do
			print(var.name, var.value)
		end
	end
end

--test()

function dynamic (name)
	for level, level_info in all_locals() do
		for idx, var in ipairs(level_info) do
			if var.name == name then
				return var.name, var.value
			end
		end
	end
end

local function make_printer()
	local a = 100
	
	return function()
		print("Lexical scoping:", a)
		-- notice we pass in "a" here
		print("Dynamic scoping:", dynamic("a"))
	end
end

local function run_func(fn)
  local a = 200
  fn()
end

local print_a = make_printer()

run_func(print_a)