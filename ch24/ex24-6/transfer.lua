


function Transfer:new (...)
	local cos = {}
	
	local args = table.pack(...)
	
	for i = 1, args.n do
		local fn = args[i]
		local g = function (val)
			fn(val)
		
		
		coroutines[fn] = coroutine.w