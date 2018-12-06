--[[
	Exercise 5.6

	Write a function to test whether a given table is a valid sequence.
]]

function is_valid_sequence (tab)
	local cnt = 0 -- count the number of entries

	for k, v in pairs(tab) do
		cnt = cnt + 1
	end

	return cnt == #tab
end

function run_tests ()
	local examples = {
		{ {1,2,3}, true },
		{ {x=3, y=4}, false},
		{ {}, true},
		{ {1,2,count="breaks"}, false},
		{ {1,2,nil,3}, false},
	}

	for _, ex in ipairs(examples) do
		local tab, expected_value = ex[1], ex[2]
		assert(is_valid_sequence(tab) == expected_value)
	end
end
