
Points = {}

function add_point(x, y)
	local proxy = {}
	Points[proxy] = {x=x, y=y}
	return proxy
end

function has_point(x, y)
	for _, point in pairs(Points) do
		if point.x == x and point.y == y then
			return point
		end
	end
	
	return false
end


print(has_point(0,0))
p1 = add_point(0,0)
print(has_point(0,0))
print(Points[p1])