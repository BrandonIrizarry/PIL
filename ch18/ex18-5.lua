--[[
	Exercise 18.5
	
	Write a true iterator that traverses all subsets of a given set.
(Instead of creating a new table for each subset, it can use the same table for all
its results, only changing its contents between iterations.)
]]

-- Make this one-based.
function bit_set (num, pos)
	pos = pos - 1 -- make this one-based; adjust to zero.
	local mask = 1 << pos
	
	return ((num & mask) >> pos) == 1 and true or nil
end
	

function subsets (set, f)
	
	local A = {} -- array to match bit positions to set elements.
	
	-- Count the number of elements in the set.
	for element in pairs(set) do
		A[#A + 1] = element
	end
	
	local size = #A -- the size of the set.
	
	local num_subsets = math.tointeger(2^size) -- the number of subsets.
	
	for i = 0, num_subsets - 1 do
		
		for bit = 1, size do
			print(bit_set(i, bit))
			set[A[bit]] = bit_set(i, bit)
		end
		
		f(set)
	end
end
	
function print_set (set)
	for element in pairs(set) do
		print(element)
	end
	
	print()
end

set1 = {house=true, watch=true, apple=true}
subsets(set1, print_set)

print_set(set1) -- notice how the iterator conveniently puts the set back together!