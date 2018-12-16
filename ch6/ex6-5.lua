--[[
	Exercise 6.5

	Write a function that takes an array and prints all combinations of the
elements in the array.
	Hint: you can use the recursive formula for combination:
C(n, m) = C(n-1, m-1) + C(n-1, m). To generate all C(n, m) combinations of n elements
in groups of size m, you first add the first element to the result and then
generate all C(n-1, m-1) combinations of the remaining elements in the remaining
slots; then you remove the first element from the result and then generate
all C(n-1, m) combinations of the remaining elements in the free slots.
	When n is smaller than m, there are no combinations. When m is zero, there
is only one combination, which uses no elements.
]]

function reload()
	dofile("ex6-5.lua")
end

function print_array (array)
	for _, v in ipairs(array) do
		io.write(tostring(v), " ")
	end

	io.write("\n")
end

-- Print each combination generated.
function print_combos(combos)
	for _, v in ipairs(combos) do
		print_array(v)
	end
end

--[[
	Note that we generate the combinations using something like

	a:C(n-1,m-1)++C(n-1,m)
]]


function C(array, n, m)

	if m == 0 then
		return {{}} -- Contains one empty combination, which can be affixed to
	elseif n < m then
		return {} -- A null list, which gets quietly absorbed when merging
	else
		-- Each call must govern its own _unique_ reference to the
		-- array whose combinations are to be computed, or else
		-- sibling recursions will alter that copy.
		local suffix = table.move(array, 2, #array, 1, {})

		-- Compute the combinations associated with C(n-1, m-1)
		local left_branch = C(suffix, n-1, m-1)

		-- Compute the combinations associated with C(n-1, m)
		local right_branch = C(suffix, n-1, m)

		-- Note that LEFT_BRANCH is never {}, so this loop shouldn't crash.
		for _, v in ipairs(left_branch) do
			table.insert(v, 1, array[1])
		end

		-- Now merge the two sides, and return the result.
		-- Note that RIGHT_BRANCH could be {}, in which case LEFT_BRANCH is left unaltered.
		for _, v in ipairs(right_branch) do
			left_branch[#left_branch + 1] = v
		end

		return left_branch
	end
end

function run_tests()

	local examples = {
		{"a", "b", "c", "d", "e"},
		{1,2,3,4,5},
	}

	for _, ex in ipairs(examples) do
		print_combos(C(ex, #ex, 3))
		print()
		print_combos(C(ex, #ex, 2))
		print(string.rep("-", 20))
	end

	-- A special example.
	local big_array, TEST_SIZE = {}, 10
	for i = 1, 20 do
		big_array[i] = i
	end

	local function factorial(n)
		if n == 0 then
			return 1
		else
			return n * factorial(n-1)
		end
	end

	local function num_combos(n,m)
		local f_n, f_nm, f_m = factorial(n),
								factorial(n - m),
								factorial(m)
		return f_n / (f_nm * f_m)
	end

	local result = C(big_array, #big_array, TEST_SIZE)

	-- The main test for our special example.
	local num = num_combos(#big_array, TEST_SIZE)
	assert(num_combos(#big_array, TEST_SIZE) == #result)
end

run_tests()

--ARRAY =
--C(ARRAY, 5,3)
--print_combos(C(ARRAY, 5, 3))
-- Print a variable number of tables given as arguments
-- (used to test the function AFFIX, see below.)
--[[
function print_tables (...)
	local arg = table.pack(...)

	for _, v in ipairs(arg) do
		for _, el in ipairs(v) do
			io.write(tostring(el), " ")
		end
		io.write("\n")
	end
end

-- Affix ELEMENT to every member (table) of the vararg list
-- '...' should contain no nils.
function affix (element, ...)
	local arg = table.pack(...)

	for _, v in ipairs(arg) do
		table.insert(v, 1, element)
	end

	return table.unpack(arg)
end

--print_tables(affix("a", {1,2,3}, {"b", "c", "d"}, { {}, {1}, {math.cos} }))

-- Append list2 to the end of list1.
-- Destructively modify list1.
function merge (list1, list2)

	for _, v in ipairs(list2) do
		list1[#list1 + 1] = v
	end
end


--[[
function C (array, n, m)

	if m == 0 then
		return {}
	elseif n >= m then

		-- Make a local copy of ARRAY for this function call.
		local array1  = table.move(array, 1, #array, 1, {})

		-- Get the first element of ARRAY1, for the append operation.
		local first = array1[1]

		-- Compute C(n-1, m-1) and C(n-1, m)
		--local SUFFIX_0, SUFFIX_1 = C(array1, n-1, m-1), C(array1, n-1, m)

		local part1 = table.pack(affix(first, C(array1, n-1, m-1)))
		local part2 = table
]]
