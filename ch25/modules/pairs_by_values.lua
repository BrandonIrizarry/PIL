

local function pairs_by_values (t)
	local bins = {}
	
	for key, value in pairs(t) do
		if bins[value] then
			table.insert(bins[value], key)
		else
			bins[value] = {key}
		end
	end
	
	local array = {}
	
	for key in pairs(bins) do
		array[#array + 1] = key
	end
	
	table.sort(array)
	
	local i = 0 -- iterator variable
	
	return function ()
		i = i + 1
		local value = array[i]
		return value, bins[value]
	end
end

local t = {
	house = 3,
	cat = 5,
	towel = 3,
	sink = 5,
	book = 4,
}

local function test ()
	for count, group in pairs_by_values(t) do
		for _, item in ipairs(group) do
			print(count, item)
		end
	end
end

return pairs_by_values

