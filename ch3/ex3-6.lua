--[[
	Write a function to compute the volume of a right circular
cone, given its height and the angle between a generatrix and the
axis.
	
	Let the length of the generatrix be H, and the radius of the base
be r. Using this information, and combining it with the more common
formula for volume, you can derive the appropriate formula to be
	
	V = pi * tan(theta) * (h^3)/3
]]

function volume (theta, height)
	return math.pi * math.tan(theta) * (height^3) / 3
end