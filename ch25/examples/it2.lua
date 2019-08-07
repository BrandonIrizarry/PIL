function next_local (_, level)
	level = level + 1
	if debug.getinfo(level + 1) == nil then return end
	local locals = {}
	
	for idx = 1, math.huge do
		local name, value = debug.getlocal(level + 1, idx)
		if not name then break end
		locals[idx] = {}
		locals[idx].name = name
		locals[idx].value = value
	end
	
	return level, locals
end

function locals ()
	return next_local, nil, 0
end

local nice = "foo"

function test ()
	local x = 1
	local y = 2
	local z = 3
	
	for level, ltable in locals() do
		print(level)
	
		for _, row in ipairs(ltable) do
			print(row.name, row.value)
		end
	end
	print()
end

test()

-- wow!  tbc - finish for upvalues, adapt for coroutines, see if you can use this to
-- solve ex25-3.