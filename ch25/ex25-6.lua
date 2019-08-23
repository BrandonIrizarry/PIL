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


local function derive_message (count, func)
	local name_info = Names[func]
		
	local base = string.format("%-15d%-20s%-15s%-5s", count, name_info.name, name_info.namewhat, 
			name_info.what)
	
	if name_info.what == "C" then
		if (name_info.name == nil) or (name_info.namewhat == nil) then return end
		return base
	end

	if name_info.what == "Lua" then
		local _lines = string.format("%d,%d", name_info.linedefined, name_info.lastlinedefined)
		return base..string.format("%30s", _lines..name_info.source)
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
	io.write("\n\n") -- make room for the profiler message

	-- An iterator to help abstract away a unique sorted traversal.
	local pairs_by_values = require "modules.pairs_by_values"
	
	for count, func_group in pairs_by_values(Counters) do
		for _, func in ipairs(func_group) do
			local msg = derive_message(count, func)
			if msg then
				print(msg)
			end
		end	
	end
end

print_data()
