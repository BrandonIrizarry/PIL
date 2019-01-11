--[[
	Exercise 13.7

	Suppose we have a binary file with a sequence of records, each one
with the following format:

	struct Record {
		int x;
		char[3] code;
		float value;
	};

Write a program that reads the file and prints the sum of the 'value' fields.
]]

--[[

	In this program we look at the top 5 busiest airports (by passenger numbers)
in the US for 2017: ATL, LAX, ORD, DFW, DEN. We calculate the sum, in millions
of passengers, of their passenger numbers for that year.
	Each airport is represented by a C struct with three fields: its rank,
its airport code, and the number of passengers it attended to (rounded to
three significant digits.)

	Stats for the airports come from:

	https://www.world-airport-codes.com/us-top-40-airports.html

	See also

	http://www.catb.org/esr/structure-packing/
	https://www.geeksforgeeks.org/readwrite-structure-file-c/
	http://www.inf.puc-rio.br/~roberto/struct/ -- for knowing to use "!4" in this case.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-7.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-7.lua")
end


airports = assert(io.open("airports.dat", "r")):read("a") -- get the data string at once.

local i = 1
local sum = 0

print("Rank", "Code", "Millions of Passengers") -- pretty-print header.
while i < #airports do
	local struct = {string.unpack("ibbb!4f", airports, i)} -- int, char[3], alignment-forced float!
	i = struct[#struct] -- jump i to the next airport's information.

	-- Decompose all available information, for documentation and testing purposes.
	local rank = struct[1]

	local code = table.concat {
		string.char(struct[2]),
		string.char(struct[3]),
		string.char(struct[4]),
	}

	local num_passengers = struct[5] -- we only need this field.

	print(rank, code, num_passengers) -- pretty-print all stats.

	sum = sum + num_passengers
end


-- Return 'num' rounded to one decimal place.
local function round (num)
	return math.floor(num * 10) / 10
end

local hand_computed = 50.2 + 41.2 + 38.5 + 31.8 + 29.8
assert(round(hand_computed), round(sum))






