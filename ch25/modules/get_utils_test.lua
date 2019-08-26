
local gu =  require "get_utils"

local function test1 ()
	local x, y, z = 0, 1, 2

	print(gu.getlocal(nil, 1, "x"))
	
	gu.setlocal(nil, 1, "x", 10)
	
	print(x)
end

test1()
