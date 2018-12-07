--[[
	Exercise 6.3

	Write a function that takes an arbitrary number of values and returns all
of them, except the last one.
]]

function all_but_last(...)
	local arg = table.pack(...)
	arg[arg.n] = nil
	return table.unpack(arg)
end

function run_tests()
	local examples = {
		{"three, ", "two, ", "one, ", "is zero here?", "zero"},
		{4,3,2,1, "is zero here?", 0},
	}

	for _, ex in ipairs(examples) do
		print(all_but_last(table.unpack(ex)))
	end
end

run_tests()
