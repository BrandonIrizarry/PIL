local mt = {}
local proxy_table = {}
	

mt.__index = function (p, k)
	print("*access to element " .. tostring(k))
	return proxy_table[p][k]
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

return { track = track }
