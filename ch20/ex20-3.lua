--[[
	Exercise 20.3
	
	An alternative way to implement read-only tables might use a function 
as the __index metamethod. This alternative makes accesses more expensive,
but the creation of read-only tables is cheaper, as all read-only tables
can share a single metatable. Rewrite the function readOnly using this
approach.
]]

-- This code is simply adapted from 'examples/proxy-all.lua'!
local mt = {}
local proxy_table = {}

mt.__index = function (p, k)
	local t = proxy_table[p]
	return t[k]
end

mt.__newindex = function ()
	error("attempt to update a read-only table", 2)
end


function readOnly (t)
	local proxy = {}
	setmetatable(proxy, mt)
	proxy_table[proxy] = t
	
	return proxy
end

local days = readOnly {	"Sunday", 
						"Monday", 
						"Tuesday", 
						"Wednesday", 
						"Thursday", 
						"Friday", 
						"Saturday"}

function test_read_only (t)
	local status_good, msg = pcall(function () t[1] = "new thing" end)

	assert(not status_good)
	print(msg)
end

test_read_only(days)

-- Try this next example.

local planets = {"Mercury", "Venus", "Earth", "Mars", "Jupiter"}
planets[#planets + 1] = "Saturn"

planets = readOnly(planets)

test_read_only(planets)

