--[[
	Exercise 6.2

	Write a function that takes an arbitrary number of values and returns
all of them, except the first one.
]]

function all_but_first(...)
	return select(2, ...)
end

function run_tests()
	local examples = {
		{1,2,3,4},
		{"first", "second", "third"},
	}

	for _, ex in ipairs(examples) do
		print(all_but_first(table.unpack(ex)))
	end
end

run_tests()
