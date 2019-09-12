--[[
	Listing 25.6
	
	Using hooks to bar calls to unauthorized functions.
]]

-- load chunk
local chunk = assert(loadfile(arg[1], "t", {}))

local debug = require "debug"

-- maximum "steps" that can be performed
local steplimit = 1000

local count = 0 -- counter for steps

-- set of authorized functions
local validfunc = {
	-- "Smuggle-able" functions, plus the chunk itself.
	[string.upper] = true,
	[string.lower] = true,
	[chunk] = true, -- for now, though getinfo can fix this/make it obsolete.
}

local function hook (event)
	print()
	print(event)
	if event == "call" then
		local info = debug.getinfo(2, "fn")
		print("\ncalling: ", info.name) -- for debugging - see where the hook trips.
	
		if info.name == "print" then
			print(info.func == print)
		end
		
		if not validfunc[info.func] then
			error("calling bad function: " .. (info.name or "?"), 3)
		end
	end
	
	count = count + 1
	if count > steplimit then
		error("script uses too much CPU")
	end
end

debug.sethook(hook, "c", 100) -- set hook
chunk()