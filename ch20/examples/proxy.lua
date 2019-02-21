local T = {}

function T.track (t)
	local proxy = {} -- proxy table for 't'
	
	-- create metatable for the proxy
	local mt = {
		__index = function (_, k)
			print("*access to element " .. tostring(k))
			return t[k] -- access the original table
		end,
		
		__newindex = function (_, k, v)
			print(string.format("*update of element %s to %s", tostring(k), tostring(v)))
			t[k] = v -- update the original table
		end,
		
		__pairs = function ()
			return function (_, k) -- iteration function
				local nextkey, nextvalue = next(t, k)
				if nextkey ~= nil then -- avoid last value
					print("*traversing element " .. tostring(nextkey))
				end
				
				return nextkey, nextvalue
			end
		end,
		
		__len = function () return #t end
	}
	
	setmetatable(proxy, mt)
	
	return proxy
end
		
return T
					