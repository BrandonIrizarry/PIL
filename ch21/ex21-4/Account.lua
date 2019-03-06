--[[
	Exercise 21.4
	
	A variation of the dual representation is to implement objects using
proxies (Section 20.4). Each object is represented by an empty proxy table.
An internal table maps proxies to tables that carry the object state. This
internal table is not accessible from the outside, but methods use it to
translate their 'self' parameters to the real tables where they operate.
	Implement the Account example using this approach and discuss its pros
and cons.
]]

local proxy_table = {}

proxy_table.__index = function (proxy_object, field)
	local t = proxy_table[proxy_object] 

	return t[k]
end

local Account = {}

function Account:new (a)
	a = a or {}
	self.__index = 


