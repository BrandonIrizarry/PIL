--[[
	Exercise 20.1
	
	Define a metamethod __sub for sets that returns the difference of two sets.
(The set a - b is the set of elements from a that are not in b.)
]]

local Set = require "examples.set"

local s1 = Set.new {1,2,3,4}
local s2 = Set.new {3,4,5,6}

local mt = getmetatable(s1)

mt.__sub = function (a, b)
	local res = Set.new {}
	
	for k in pairs(a) do
		res[k] = true
	end
	
	for k in pairs(b) do
		res[k] = nil
	end
	
	return res
end

print(s1 - s2)
