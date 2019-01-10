--[[
	Exercise 13.4

	Write a function to compute the Hamming weight of a given integer.
(The Hamming weight of a number is a number of ones in its binary representation.)
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-4.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-4.lua")
end

function hamming (heap)
	local sum = 0

	while heap ~= 0 do
		sum = sum + (heap & 1) -- add current parity digit to sum
		heap = heap >> 1
	end

	return sum
end

-- An alternate version, kept for reference.
function hamming_gm (x)
	local count =  0
	local repr = string.format("%x", x)

	local key = {
		["0"] = 0, -- 0000
		["1"] = 1, -- 0001
		["2"] = 1, -- 0010
		["3"] = 2, -- 0011
		["4"] = 1, -- 0100
		["5"] = 2, -- 0101
		["6"] = 2, -- 0110
		["7"] = 3, -- 0111
		["8"] = 1, -- 1000
		["9"] = 2, -- 1001
		["a"] = 2, -- 1010
		["b"] = 3, -- 1011
		["c"] = 2, -- 1100
		["d"] = 3, -- 1101
		["e"] = 3, -- 1110
		["f"] = 4, -- 1111
	}

	for hex in repr:gmatch("%x") do -- match each hex digit
		count = count + key[hex]
	end

	return count
end

local examples = {
	{0xa, 2},
	{math.maxinteger, 63},
	{math.mininteger, 1},
	{-1, 64},
	{0, 0},
	{1, 1},
	{0x1c2, 4},
}

for _, ex in ipairs(examples) do
	local number, hamming_val = ex[1], ex[2]

	assert(hamming(number) == hamming_val)
end

