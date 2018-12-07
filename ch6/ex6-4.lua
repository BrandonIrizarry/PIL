--[[
	Exercise 6.4

	Write a function to shuffle a given list. Make sure that all permutations are
equally probable.
]]

-- What makes sure that all permutations are equally probable.
math.randomseed(os.time())

function shuffle_list(list)
	local result = {}

	for i = 1, #list do
		local index = math.random(#list)
		local new_thing = table.remove(list, index)
		result[#result + 1] = new_thing
	end

	-- Overwrite the table pointed to by LIST, using RESULT
	table.move(result, 1, #result, 1, list)
end

function print_array(array)
	for _, v in ipairs(array) do
		io.write(v)
	end
	io.write("\n")
end

function find_char_position (example)
	for i, v in ipairs(example) do
		if v ~= " " then
			return i
		end
	end
end

-- Supply an optional length parameter for formatting the output
function run_tests(len)

	local LEN = len or 20

	local function make_table (char)
		local example = {}

		for i = 1, LEN do
			example[#example + 1] = "."
		end

		example[1] = char
		return example
	end

	local examples = {
		make_table("X"),
		make_table("Y"),
	}

	-- Run the test multiple times, to demonstrate randomness of shuffling.
	for i = 1, 10 do
		for _, ex in ipairs(examples) do
			shuffle_list(ex)
			print_array(ex)
		end

		io.write("\n")
	end
end

run_tests()
