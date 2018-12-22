--[[
	Exercise 9.3

	Exercise 5.4 asked you to write a function that receives a polynomial
(represented as a table) and a value for its variable, and returns the
polynomial value.
	Write the _curried_ version of that function. Your function should
receive a polynomial and return a function that, when called with a value
for x, returns the value of the polynomial for that x. See the example:

f = newpoly({3,0,1}) [note that this is x^2 + 3.]
print(f(0)) --> 3
print(f(5)) --> 28
print(f(10)) --> 103
]]

-- Use the non-exponentiation version, for kicks
-- (and to see if we remember how to write it!)
function newpoly (poly)
	return function (x)
		local sum = 0

		for i = #poly, 1, -1 do
			sum = sum * x + poly[i]
		end

		return sum
	end
end

-- Some tests.
f = newpoly({3,0,1})
assert(f(0) == 3)
assert(f(5) == 28)
assert(f(10) == 103)
