--[[
	Exercise 13.6

	Implement a bit array in Lua. It should support the following operations:

	- newBitArray(n) (creates an array with n bits),

	- setBit(a, n, v) (assigns the Boolean value v to bit n of array n),

	- testBit(a, n) (returns a Boolean with the value of bit n).
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-6.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-6.lua")
end

function newBitArray (n)

	local num_buckets = math.ceil(n/64)
	local bit_array = {}

	for i = 1, num_buckets do
		bit_array[#bit_array + 1] = 0
	end

	bit_array.n = n

	return bit_array
end


function setBit (a, k, v)

	if k < 1 or k > a.n then
		print("Warning: setting out of bounds, array intact")
		return false
	end

	local bucket = math.ceil(k/64)

	-- Find the position (index) within the integer.
	local pos = (k - 1) % 64 -- "k % 64" => zero-indexed, but keep it 1-indexed.

	-- Create the mask for setting the bit.
	local mask = 1 << pos

	if v then
		a[bucket] = a[bucket] | mask
	else
		a[bucket] = a[bucket] & ~mask
	end

	return true
end

function testBit (a, k)
	if k < 1 or k > a.n then
		error("Warning: testing out of bounds")
	end

	local bucket = math.ceil(k/64)

	local mask = 1 << ((k - 1) % 64)

	return a[bucket] & mask ~= 0
end

function pbarray (a)

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

	for i, int in ipairs(a) do
		local hex = string.format("%x", int) -- hex repr of int of current bucket.
	--	local bin = hex:gsub("%x", hex_as_binary) -- for seeing bit changes more clearly.
		local bin = hex -- try just hex for now, maybe we can handle it :)
		local left_msg = string.format("%d to %d:", (i - 1) * 64 + 1, i * 64) -- index crunching.
		local msg = string.format("%-13s%20s", left_msg, bin) -- nicely format the output.
		print(msg)
	end
end

function test1 () -- test making a simple bit array
	print("\n-- Make a bit array of size 65, and print some stats")
	local A = newBitArray(65)
	print(A.n, #A) -- #A = number of buckets, n = number of accessible bits.
	pbarray(A)
end

function test2 ()
	print("\n-- Test Suite #2: Some more tests")
	local A = newBitArray(65)
	print("\n-- Let's set the last bit (bit #65; remember, we're one-indexed)")
	assert(setBit(A, 65, true)) -- see if we can set the last bit.
	pbarray(A)
	print("\n-- Now, try setting beyond the range")
	assert(not setBit(A, 66, true)) -- set a bit outside the range.
	pbarray(A)
	print("\n-- Again, but before 1")
	assert(not setBit(A, 0, true)) -- again, but < 1.
	pbarray(A)
	print("\n-- Let's set another bit (bit 12)")
	assert(setBit(A, 12, true)) -- set another bit.
	pbarray(A)
	print("\n-- Clear the last bit")
	assert(setBit(A, 65, false))
	pbarray(A)
	print("\n-- Set bit 64, see what happens")
	assert(setBit(A, 64, true))
	pbarray(A)

	print("\n-- Now, let's test some bits (bit 64,12,1,14,65)")
	print(testBit(A, 64))
	print(testBit(A, 12))
	print(testBit(A, 1))
	print(testBit(A, 14))
	print(testBit(A, 65))

	print("\n-- Set and then retest bit 65")
	setBit(A, 65, true)
	print(testBit(A, 65))
end

function test3 ()
	local A = newBitArray(1000)

	-- Set a bunch of random bits.
	print("\n-- In this test, we randomly set some bits (size 1000)")
	local hits = {}
	for i = 1, 200 do
		local k_hit = math.random(1, 1000)
		hits[#hits + 1] = k_hit
		setBit(A, k_hit, true)
	end

	pbarray(A)

	print("\n-- Now, unset all those bits")
	for _, k_hit in ipairs(hits) do
		setBit(A, k_hit, false)
	end

	pbarray(A)
end

test1()
test2() -- probably the most interesting one.
test3()
