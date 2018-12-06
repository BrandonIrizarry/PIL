--[[
	Exercise 5.5.

	Can you write the function from the previous item so that it uses at most
n additions and n multiplications (and no exponentiations?)
]]

-- tbc
function print_poly (poly)
	for _, term in ipairs(poly) do
		io.write(term, " ")
	end
	io.write("\n")
end

function compute_poly (poly, x)

	-- This set of recursive calls must use a local copy of POLY,
	-- or else future computations of COMPUTE_POLY will be affected,
	-- as the global copy of POLY will have been modified destructively.
	local poly = table.move(poly, 1, #poly, 1, {})

	-- Count the number of times the recursive case of COMPUTE_POLY1 is called,
	-- to prove that COMPUTE_POLY uses at most n additions and
	-- n multiplications.
	local cnt = 0

	-- The actual recursive function to compute the polynomial at x
	local function compute_poly1 (poly)


		local degree, first_term = #poly - 1, poly[1]

		if degree == 0 then
			return first_term
		else
			-- record the recursive call to COMPUTE_POLY1
			cnt = cnt + 1

			-- Obtain the shifted polynomial
			table.move(poly, 2, #poly, 1)
			poly[#poly] = nil

			return first_term + x * compute_poly1(poly, x)
		end
	end

	-- Note that we also return the final value of CNT.
	return compute_poly1(poly), cnt
end

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
			local degree = #poly - 1
			local ans, cnt = compute_poly(poly, i)

			if cnt > degree then
				io.write(string.format("Degree: %d, Count: %d; Example: %d, Val_x: %d\n",
										degree, cnt, num, i))

			end

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
end
