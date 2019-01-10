--[[
	Exercise 13.5

	Write a function to test whether the binary representation of a given
integer is a palindrome.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-5.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-5.lua")
end

function is_palindrome (x)

	local hex_as_binary = {
		["0"] = "0000",
		["1"] = "0001",
		["2"] = "0010",
		["3"] = "0011",
		["4"] = "0100",
		["5"] = "0101",
		["6"] = "0110",
		["7"] = "0111",
		["8"] = "1000",
		["9"] = "1001",
		["a"] = "1010",
		["b"] = "1011",
		["c"] = "1100",
		["d"] = "1101",
		["e"] = "1110",
		["f"] = "1111",
	}

	local s = string.format("%x", x) -- convert to a hex string.
	local full_binary = s:gsub("%x", hex_as_binary) -- convert to a binary string.
	full_binary = full_binary:gsub("^0*(.-)", "%1") -- remove leftmost zeroes.

	return full_binary == full_binary:reverse()
end
