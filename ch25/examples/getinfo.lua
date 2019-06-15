
local x = 12

function foo (y, ...)
	print(y)
	arg = table.pack(...)
	
	return 42 + x
end

S = debug.getinfo(foo)