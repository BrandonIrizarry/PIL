--[[
	Compare the performance of Lua programs that copy the standard input stream to
the standard output stream in the following ways:
	- byte by byte;
	- line by line;
	- in chunks of 8 kB;
	- the whole file at once.

For the last option, how large can the input file be?
]]

io.input("../data/big.txt")

function run_test(read_option)

	local valid = read_option == "L" or read_option == 1
					or read_option == 2^13 or read_option == "a"

	assert(valid)

	local start = os.clock()

	if read_option == "a" then
		io.write(io.input():read("a"))
	else
		for block in io.input():lines(read_option) do
			io.write(block)
		end
	end

	-- Reset the file pointer.
	io.input():seek("set")

	return os.clock() - start
end

function run_tests()

	-- Compute the acutal test results (times)
	local results = {
		by_line = run_test("L"),
		by_byte = run_test(1),
		by_block = run_test(2^13),
		whole_file = run_test("a")
		-- For this last option, the file size can't exceed one's free RAM
		-- e.g. free -h says I have 2.1 G free right now - that's the limit.
	}

	-- Identify each time with its read option.
	local register = {
		[results.by_line] = "Line by line:",
		[results.by_byte] = "Byte by byte:",
		[results.by_block] = "In chunks of 8 kB:",
		[results.whole_file] = "The whole file at once:"
	}

	-- Used to sort the times from fastest to slowest.
	local times = {
		results.by_line,
		results.by_byte,
		results.by_block,
		results.whole_file
	}

	table.sort(times)

	print(string.rep("-", 10))
	print("Speed record (fastest to slowest):")
	for _, v in ipairs(times) do
		print(string.format("%-24s %f", register[v], v))
	end
end

run_tests()
