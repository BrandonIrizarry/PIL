local M = {}

function M.disk (cx, cy, r)
	return
		function (x, y)
			return (x - cx)^2 + (y - cy)^2 <= r^2
		end
end

function M.rect (left, right, bottom, up)
	return
		function (x, y)
			return left <= x and x <= right and
					bottom <= x and x <= up
		end
end

return M
