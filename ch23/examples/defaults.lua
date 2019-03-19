local defaults = setmetatable({}, {__mode = "k"})
local redirect = {__index = function (client) return defaults[client] end}

function set_default (table_a, defval)
	defaults[table_a] = defval
	setmetatable(table_a, redirect)
end

local points = {p1 = {x=1,y=2}, p2 = {x=3,y=4}}
set_default(points, {x=0,y=0})

print(points.p1.x, points.p1.y)
print(points.p2.x, points.p2.y)
print(points.p0.x, points.p0.y)
print(points.a1.x, points.a1.y)

