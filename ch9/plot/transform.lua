local M = {}

function M.complement (r)
	return
		function (x, y)
			return not r(x, y)
		end
end

function M.union (r1, r2)
	return
		function (x, y)
			return r1(x, y) or r2(x, y)
		end
end

function M.intersection (r1, r2)
	return
		function (x, y)
			return r1(x, y) and r2(x, y)
		end
end

function M.difference (r1, r2)
	return
		function (x, y)
			return r1(x, y) and not r2(x, y)
		end
end

function M.translate (r, dx, dy)
	return
		function (x, y)
			return r(x - dx, y - dy)
		end
end

-- For Exercise 9.5.
function M.rotate (r, theta) -- counterclockwise theta radians.
	return
		function (x, y)
			local cos, sin = math.cos, math.sin
			local x_prime = x * cos(theta) - y * sin(theta)
			local y_prime = x * sin(theta) + y * cos(theta)
			return r(x_prime, y_prime)
		end
end

return M
