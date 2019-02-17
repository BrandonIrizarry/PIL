--[[
	Exercise 17.2
	
	Rewrite the implementation of the geometric-region system
(Section 9.4) as a proper module.
]]

local M = {}

-- Shapes.
function M.disk (cx, cy, r)
	return function (x, y)
		return (x - cx)^2 + (y - cy)^2 <= r^2
	end
end

function M.rect (left, right, bottom, up)
	return function (x, y)
		return left <= x and x <= right and 
				bottom <= y and y <= up
	end
end
	

-- Transformations.
function M.complement (r)
	return function (x, y)
		return not r(x, y)
	end
end

function M.union (r1, r2)
	return function (x, y)
		return r1(x, y) or r2(x, y)
	end
end

function M.intersection (r1, r2)
	return function (x, y)
		return r1(x, y) and r2(x, y)
	end
end

function M.difference (r1, r2)
	return function (x, y)
		return r1(x, y) and not r2(x, y)
	end
end

function M.translate (r, dx, dy)
	return function (x, y)
		return r(x - dx, y - dy)
	end
end

function M.rotate (r, theta) -- counterclockwise theta radians.
	return
		function (x, y)
			local cos, sin = math.cos, math.sin
			local x_prime = x * cos(theta) - y * sin(theta)
			local y_prime = x * sin(theta) + y * cos(theta)
			return r(x_prime, y_prime)
		end
end

function M.plot (r, M, N)
	io.write("P1\n", M, " ", N, "\n") -- header
	for i = 1, N do
		local y = (N - i*2)/N -- scale y to [-1,1)

		for j = 1, M do
			local x = (j*2 - M)/M
			io.write(r(x, y) and "1" or "0")
		end
		io.write("\n")
	end
end
	


return M