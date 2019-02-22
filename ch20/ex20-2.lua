--[[
	Exercise 20.2
	
	Define a metamethod __len for sets so that #s returns the number of
elements in the set s.
]]

local Set = require "examples.set"

local s1 = Set.new {1,2,3,4}
local s2 = Set.new {}

local mt = getmetatable(s1)

mt.__len = function (s)
	local count = 0
	
	for k in pairs(s) do
		count = count + 1
	end
	
	return count
end

-- Test this one.

print(#s1, #s2) -- 4, 0