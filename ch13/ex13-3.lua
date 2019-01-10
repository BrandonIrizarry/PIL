--[[
	Exercise 13.3

	How can you test whether a given integer is a power of two?
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-3.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-3.lua")
end

-- A number x is a power of two iff x & -x == |x|.
function power_of_two (x)
	return (x ~= 0) and (x & -x == math.abs(x))
end

local true_numbers = {
	1,
	2,
	4,
	8,
	16,
	math.mininteger,
}

local false_numbers = {
	0,
	3,
	5,
	math.maxinteger,
}

function run_tests()
	for i, num in ipairs(true_numbers) do
		assert(power_of_two(num) and power_of_two(-num))
	end

	for _, num in ipairs(false_numbers) do
		assert(not (power_of_two(num) or power_of_two(-num)))
	end

	print("Congratulations, all tests passed.")
end

run_tests()
