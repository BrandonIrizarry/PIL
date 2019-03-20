local results = {}
setmetatable(results, {__mode = "v"})

--local results = setmetatable({}, {__mode = "v"})

function create_rgb (r, g, b)
	local key = string.format("%d-%d-%d", r, g, b)
	local color = results[key]
	
	if color == nil then
		color = {red = r, green = g, blue = b}
		results[key] = color
	end
	
	return color
end

c1 = create_rgb(1,2,3)
c2 = create_rgb(100,100,100)
--c3 = create_rgb(1,2,3)
c1 = create_rgb(34,34,34)

collectgarbage()

--[[
print(results["1-2-3"])
print(results["100-100-100"])
--]]
for k,v in pairs(results) do
	print(k,v)
end

