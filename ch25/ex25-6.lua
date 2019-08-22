--[[
	Exercise 25.6
	
	Implement some of the suggested improvements for the basic profiler
that we developed in Section 25.3.
]]


if not arg[1] then
	print("Usage: something.lua")
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

local function getname (func)
	local n  = Names[func]
	
	if n.what == "C" then
		return n.name
	end
	
	local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
	
	if n.what ~= "main" and n.namewhat ~= "" then
		return string.format("%s (%s)", lc, n.name)
	else
		return lc
	end
end

local prefix = "local arg = {...};"
local filetext = prefix .. io.open(arg[1]):read("a")

--local f_main = assert(loadfile(arg[1]))
local f_main = assert(load(filetext))
debug.sethook(hook, "c")
f_main(2, "../data/big.txt") -- right now, hardcoded to run ex19-1.lua, the Markov exercise.
debug.sethook()

function run_c ()
	for func, count in pairs(Counters) do
		print(getname(func), count)
	end
end

function run_n ()
	for func, name_set in pairs(Names) do
		-- Leave two lines of space to differentiate from possibly voluminous output.
		local message = string.format([[


name: %s
namewhat: %s
source: %s
short_src: %s
what: %s
linedefined: %s
lastlinedefined: %s
]],
name_set.name,
name_set.namewhat,
--name_set.source,
"source is here.",
name_set.short_src,
name_set.what,
name_set.linedefined,
name_set.lastlinedefined)

		print(message)
		print(Counters[func])
	end
end

run_n()
