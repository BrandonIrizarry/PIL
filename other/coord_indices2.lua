


Points = {}

function add_point (x, y)
	Points[x] = y
end

function has_point (x, y)
	if Points[x] then
		return x, y
	end
	
	return false
end