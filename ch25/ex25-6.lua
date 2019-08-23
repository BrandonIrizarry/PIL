--[[
	Exercise 25.6
	
	Implement some of the suggested improvements for the basic profiler
that we developed in Section 25.3.
	
	tbc - to make formatting easier, there should only be one kind
of message format for everything - each entry will neatly align into
columns.
]]


if not arg[1] then
	print("Usage: lua ex25-6.lua file.lua <args for file.lua>")
	return 
end

local Counters = {}
local Names = {}

local function hook ()
	local f = debug.getinfo(2, "f").func
	local count = Counters[f]
	
	if count == nil then 
		Counters[f] = 1
		Names[f] = debug.getinfo(2, "Sn")
	else
		Counters[f] = count + 1
	end
end


local function derive_message (func)
	local name_info = Names[func]
	
	local what, name, namewhat = name_info.what, name_info.name, name_info.namewhat
	
	if what == "C" then
		if (name == nil) or namewhat == nil then return end
		
		return string.format("%10s (%10s, C function)", name, namewhat)
	end
	
	local source, short_src = name_info.source, name_info.short_src
	local pretty_src = source
	
	if source:sub(1,1) ~= "@" then -- 'source' is possibly quite long
		pretty_src = short_src
	end
		
	--[[
	if what == "main" then
		local msg
		
		if name then
			return string.format("main:%s, %10s", name, pretty_src)
		end
		
		return string.format("main, %10s", pretty_src)
	end
	]]
	
	local linedefined, lastlinedefined = name_info.linedefined, name_info.lastlinedefined
	
	if what == "Lua" then
		return string.format("%10s (%10s, %10s, %10s, %4d-%4d)",
			name, namewhat, "Lua function", pretty_src, linedefined, lastlinedefined)
	end
end

-- Note that if we simply write env = _ENV, env becomes a reference to 
-- the _current_ environment, and so assignments to it will have unintended
-- consequences, e.g., 'loadfile' will try to load a file called '2'!
-- So we use inheritance.
-- Hardcoding the Markov example, we would then do:
-- env.arg = {2, "../data/big.txt"}
-- to simulate an arg table for that chunk. Below is a generalization of this.

local env = setmetatable({}, {__index = _ENV})
env.arg = {}
for i, a in ipairs(arg) do
	if i > 1 then
		table.insert(env.arg, a)
	end
end
		

local f_main = assert(loadfile(arg[1], "t", env))
debug.sethook(hook, "c")
f_main()
debug.sethook()


-- This is our main profile-outputter.
local function print_data ()
	io.write("\n")

	-- An iterator to help abstract away a unique sorted traversal.
	local pairs_by_values = require "modules.pairs_by_values"
	
	for count, func_group in pairs_by_values(Counters) do
		for _, func in ipairs(func_group) do
			local msg = derive_message(func)
			if msg then
				print(count, msg)
			end
		end	
	end
end

print_data()
