--[[
	Exercise 6.1

	Write a function that takes an array and prints all its elements.
]]

-- Print an array (proper sequence, that is, no nil entries.)
function print_array(array)
	for _, v in ipairs(array) do
		print(v)
	end
end

function run_tests()
	local examples = {
		{'a', 'b', 'c', 'd'},
		{math.sin, math.cos, math.tan},
		{},
		{1,2,3,4},
	}

	for _, ex in ipairs(examples) do
		print_array(ex)
	end
end

run_tests()
