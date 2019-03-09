


mt = {}
mt.__index = function (_, key)
	print(key.x, key.y)
	return nil
end

mt.__newindex = function (_, key, value)
	local proxy = {}

p = {}

setmetatable(p, mt)