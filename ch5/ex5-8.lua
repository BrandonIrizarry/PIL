--[[
	Exercise 5.8

	The table library offers a function table.concat, which receives a list
of strings and returns their concatenation:

print(table.concat({"hello", " ", "world"}))

Write your own version of this function.
	Compare the performance of your implementation against the built-in version
for large lists, with hundreds of thousands of entries. (You can use a for loop
to create those large lists.
]]

-- My home-made version of table.concat.
function slow_concat (str_list)
	local aggregate = "" -- the accumulated result

	for i = 1, #str_list do
		aggregate = aggregate .. str_list[i]
	end

	return aggregate
end

-- A function that returns a list of strings of some 500,000+ entries.
function large_list ()
	local message = {}

	for i = 1, 2^20 do
		message[#message + 1] = "a"
	end

	return message
end

-- Show the benchmark results of both functions.
function run_tests ()
	local message = large_list()

	-- Around a tenth of a second.
	local t_0 = os.clock()
	table.concat(message)
	print(string.format("Elapsed time for table.concat: %.2f seconds", os.clock() - t_0))


	-- Around five minutes.
	t_0 = os.clock()
	slow_concat(message)
	print(string.format("Elapsed time for slow_concat: %.2f minutes", os.clock()/60 - t_0))
end

run_tests()
