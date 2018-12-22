--[[
	Exercise 5.5.

	Can you write the function from the previous item so that it uses at most
n additions and n multiplications (and no exponentiations?)
]]

function print_poly (poly)
	for _, term in ipairs(poly) do
		io.write(term, " ")
	end
	io.write("\n")
end

function compute_poly(poly, x)
	local sum = 0

	for i = #poly, 1, -1 do
		sum = sum * x + poly[i]
	end

	return sum
end

-- TESTS
examples = {
	{1, 1, 1},  -- x2 + x + 1
	{1, 0, 1},  -- x2 + 1
	{-1, 0, 1}, -- x2 - 1
	{0, -1, 0, -5}, -- -5x3 - x
}

function run ()
	for _, poly in ipairs(examples) do
		print_poly(poly)
	end
end

function run_tests ()
	for num, poly in ipairs(examples) do
		for i = 0, 2 do
			local ans = compute_poly(poly, i)

			if num == 1 then
				if i == 0 then
					assert(ans == 1)
				elseif i == 1 then
					assert(ans == 3)
				elseif i == 2 then
					assert(ans == 7)
				else
					print("Warning: Index 'i' has gone out of bounds for num == 1")
				end
			elseif num == 2 then
				if i == 0 then
					assert(ans == 1)
				elseif i == 1 then
					assert(ans == 2)
				elseif i == 2 then
					assert(ans == 5)
				else
					print("Warning: Index 'i' has gone out of bounds for num == 2")
				end
			elseif num == 3 then
				if i == 0 then
					assert(ans == -1)
				elseif i == 1 then
					assert(ans == 0)
				elseif i == 2 then
					assert(ans == 3)
				else
					print("Warning: Index 'i' has gone out of bounds for num == 3")
				end
			elseif num == 4 then
				if i == 0 then
					assert(ans == 0)
				elseif i == 1 then
					assert(ans == -6)
				elseif i == 2 then
					assert(ans == -42)
				else
					print("Warning: Index 'i' has gone out of bounds for num == 4")
				end
			end
		end
	end

	print("All assertions passed!")
end

run_tests()
