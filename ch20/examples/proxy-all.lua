--[[
	This is an implementation of the suggestion on p. 195 to monitor several tables
with a single metatable.
]]


local mt = {}
local proxy_table = {}
	
--[[
	In these metamethods, the 'p' parameter is a client of the metatable - 
this client is registered with the metatable in the function 'track'
as the exclusive key that is used to access the original table in
'proxy_table'.
]]

mt.__index = function (p, k)
	local t = proxy_table[p] -- for clarity, to make it look more like Listing 20.2
	print("*access to element " .. tostring(k))
	return t[k]
end

mt.__newindex = function (p, k, v)
	local t = proxy_table[p]
	print(string.format("*update of element %s to '%s'", tostring(k), tostring(v)))
	t[k] = v
end

mt.__pairs = function (p)
	
	local t = proxy_table[p]
	
	return function (_, k)
		local nextkey, nextvalue = next(t, k)
		
		if nextkey ~= nil then
			print("*traversing element " .. tostring(nextkey))
		end
		
		return nextkey, nextvalue
	end
end

mt.__len = function (p)
	local t = proxy_table[p]
	return #t
end
		
function track (t)

	local proxy = {}
	setmetatable(proxy, mt)
	proxy_table[proxy] = t
	
	return proxy
end

-- Usage.

local t = {}
t = track(t)

t[1] = "get me in here before it's too late!"

for i = 2, 10 do
	t[i] = i
end

print(t[1], t[2], t[3])

print()
print()

for k,v in pairs(t) do
	print(k,v)
end

print(#t)