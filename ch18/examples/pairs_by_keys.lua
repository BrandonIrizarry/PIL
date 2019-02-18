function pairs_by_keys (t, f)
	local a = {}
	
	for n in pairs(t) do -- create a list (sequence) with all the keys
		a[#a + 1] = n
	end
	
	table.sort(a, f) 	-- sort the list
	local i = 0			-- iterator variable (not the control!)
	
	return function () 	-- iterator function
		i = i + 1
		return a[i], t[a[i]] 	-- return value in seq -> key -> value
	end
end

local lines = {
	["luaH_set"] = 10,
	["luaH_get"] = 24,
	["luaH_present"] = 48,
}

for name, line in pairs_by_keys(lines) do
	print(name, line) -- alphabetical order!
end