--[[
for i = 1, 100 do 
	local n, v = debug.getlocal(1, i)
	if not n then break end
end
]]

--[[
for i = 1, 10 do
end
]]
--[[
function add (x, y)
	return x + y
end

local y = 10

add(2,3)
]]

local ll = "b"
ll:upper("b")

local function add (x,y)
	return x + y
end

local sum = add(2,3)

function sub (x, y)
	return x - y
end

local diff = sub(3,2)

--print(sum)

--[[
function sub (x, y) -- global
	return x - y
end
sub(2,1)
--]]

--[[
local x = "foo"
x:match("f")
--]]
