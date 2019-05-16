local bag = require "bag"
local raw1 = {mints=5, reeses=3, twix=4, ["m&m"]=12}

function test1 ()

	local bag = bag:new(raw1)
	bag:_print()
end
	
test1()