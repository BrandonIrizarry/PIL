local Set = {}


local mt = {} -- the metatable for sets.


-- create a new set with the values of a given list
function Set.new (l)
	local set = {}
	setmetatable(set, mt) -- this needs to have an assignment above, not below!
	for _, v in ipairs(l) do set[v] = true end
	return set
end

function Set.union (a, b)
	local res = Set.new{}
	for k in pairs(a) do res[k] = true end
	for k in pairs(b) do res[k] = true end
	return res
end

function Set.intersection (a, b)
	local res = Set.new{}
	for k in pairs(a) do
		res[k] = b[k]
	end

	return res
end

-- Presents a set as a string
function Set.tostring (set)
	local l = {} -- list to put all elements from the set
	for e in pairs(set) do
		l[#l + 1] = tostring(e)
	end

	return "{" .. table.concat(l, ", ") .. "}"
end



mt.__add = Set.union
mt.__mul = Set.intersection

mt.__le = function (a, b) -- subset (proper or otherwise)
	for k in pairs(a) do
		if not b[k] then return false end
	end
	
	return true
end

mt.__lt = function (a, b)
	return not (b <= a) and a <= b
end

return Set

