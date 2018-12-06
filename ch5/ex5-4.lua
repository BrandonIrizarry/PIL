--[[
	Exercise 5.4

	We can represent a polynomial a_nx^n + a_n-1x^n-1 + ... + a_1x^1 + a_0 in Lua
as a list of coefficients, such as {a_0, a_1, ..., a_n}.
	Write a function that takes a polynomial (represented as a table) and a value
for x and returns the polynomial value.
]]

function compute_poly (poly, x)

	local ans = 0
	local degree = #poly - 1

	for i = 0, degree do
		ans = ans + poly[i + 1] * x ^ i
	end

	return ans
end

local examples = {
	{1, 1, 1},  -- x2 + x + 1
	{1, 0, 1},  -- x2 + 1
	{-1, 0, 1}, -- x2 - 1
	{0, -1, 0, -5}, -- -5x3 - x
}

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
		print(ans)
	end
	print(string.rep("-", 10))
end
