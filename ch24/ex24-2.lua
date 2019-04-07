--[[
	Exercise 24.2
	
	Exercise 6.5 asked you to write a function that prints all combinations of
the elements in a given array.
	Use coroutines to transform this function into a generator for combinations,
to be used like here:

	for c in combinations({"a", "b", "c"}, 2) do
		printResult(c)
	end
]]

function print_array (array)
	for _, val in ipairs(array) do
		io.write(tostring(val), " ")
	end
	
	io.write("\n")
end

-- Print each combination generated.
function print_combos(combos)
	print()
	for _, combo in ipairs(combos) do
		print_array(combo)
	end
end


function C(array, m, SUM)
	local n = #array
	
	if m == 0 then return {{}} end
	if n < m then return {} end
	
	-- Each subrecursion is given its own integral copy of the input array.
	local suffix = table.move(array, 2, #array, 1, {})

	-- Compute the combinations associated with C(n-1, m-1)
	local left_branch = C(suffix, m-1, SUM)

	-- Compute the combinations associated with C(n-1, m)
	local right_branch = C(suffix, m, SUM)
	
	-- The 'affix' step.
	for _, pre_i in ipairs(left_branch) do
		table.insert(pre_i, 1, array[1])
		if n + m == SUM then coroutine.yield(pre_i) end
	end

	-- The 'concatenation' step.
	for _, rest_i in ipairs(right_branch) do
		if n + m == SUM then coroutine.yield(rest_i) end
		left_branch[#left_branch + 1] = rest_i
	end

	return left_branch
end

function combinations (a, m)

	-- The 'SUM' parameter helps us identify where we have a "final answer"
	-- we can yield as a "generated value."
	return coroutine.wrap(function () C(a, m, #a + m) end)
end


-- Some tests.
for c in combinations({1,2,3,4}, 3) do
	print_array(c)
end

print(string.rep("-", 20))

for c in combinations({"a", "b", "c", "d", "e"}, 4) do
	print_array(c)
end
