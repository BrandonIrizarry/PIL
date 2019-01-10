--[[
	Exercise 13.2

	Implement different ways to compute the number of bits in the representation of a Lua integer.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-2.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-2.lua")
end


local ways = {
	function ()
		local xs = string.pack("j", 1) -- pack x as a Lua integer.

		return #xs * 8 -- #xs = num bytes, * 8 = num bits.
	end,

	function ()
		for i = 1, math.huge do
			local measurer = 1
			if measurer << i == 0 then -- have 1 "run off the screen"
				return i
			end
		end
	end,

	function ()
		local neg_1_str = string.format("%x", -1) -- get ff..ffff.
		return #neg_1_str * 4
	end,

	function ()
		for i = 1, math.huge do
			local measurer = math.mininteger
			if measurer >> i == 0 then -- run, but from left to right.
				return i
			end
		end
	end,

	function ()
		local pos_size = math.log(math.maxinteger, 2)
		return math.tointeger(pos_size) + 1 -- use log to compute num digits.
	end,

	function ()
		local heap = -1 -- all ones.
		local sum = 0

		while heap ~= 0 do
			sum = sum + (heap & 1) -- add current parity digit to sum
			heap = heap >> 1
		end

		return sum
	end,
}

print(string.format("You currently have %d functions.", #ways))

-- First test: test against a known size of 64
for _, way in ipairs(ways) do

	local NUM_BITS = way()

	assert(NUM_BITS == 64) -- we know a Lua int is 64 bits wide here.
end

-- Second test: See if all functions agree on one value.
local agreement = ways[1]() == ways[2]()

for i = 2, #ways - 1 do
	agreement = agreement and ways[i]() == ways[i + 1]()
end

assert(agreement)

print(string.format("Looks like all %d functions pass, congratulations.", #ways))
