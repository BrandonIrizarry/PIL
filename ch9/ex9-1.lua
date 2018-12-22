--[[
	Exercise 9.1

	Write a function 'integral' that takes a function
f and returns an approximation of its integral.
]]

-- Based on
-- https://en.wikipedia.org/wiki/Riemann_sum#Trapezoidal_rule
function integral (f)
	return function (a, b, n)
		local delta = (b - a) / n
		local msum = 0 -- the 'middle sum'

		for i = 1, n - 1 do -- i == 0 and i == b don't take a factor of two
			msum = msum + 2 * f(a + i * delta)
		end

		return (msum + f(a) + f(b)) * delta * 0.5
	end
end
