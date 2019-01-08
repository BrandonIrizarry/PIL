--[[
	Exercise 13.2

	Implement different ways to compute the number of bits in the representation of a Lua integer.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-2.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-2.lua")
end


function count_modshift (x)
	local count = 0

	while x ~= 0 do
		count = count + (x % 2)
		x = x >> 1
	end

	return count
end


function count_gmatch (x)
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
