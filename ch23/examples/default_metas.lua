

local metas = {}
setmetatable(metas, {__mode = "v"})

function setDefault (t, d)
	local mt = metas[d]
	
	if mt == nil then
		mt = {__index = function () return d end}
		metas[d] = mt -- memorize
	end
	
	setmetatable(t, mt)
end

local t1 = {doe = "a deer", re = "a drop", mi = "a name"}
local t2 = {apple = "fruit", corn = "vegetable"}
local t3 = {new_york = "albany", pennsylvania = "philadelphia"}

setDefault(t1, "I don't know")
setDefault(t2, "I don't know")
setDefault(t3, "Springfield")
--t1 = nil
--t2 = nil

-- When I delete the main tables, their metatables are no longer in use,
-- and so get garbage collected (because they are weak values).
collectgarbage()

for k,v in pairs(metas) do
	print(k,v)
end