function next_local (co, level)
	level  = level + 1
	
	local valid = (co and debug.getinfo(co, level)) or debug.getinfo(level + 1)
	
	if valid == nil then return end
	local locals = {}
	
	for idx = 1, math.huge do
		local name, value 
		if co then
			name, value = debug.getlocal(co, level, idx)
		else
			name, value = debug.getlocal(level + 1, idx)
		end
		
		if not name then break end
		locals[idx] = {}
		locals[idx].name = name
		locals[idx].value = value
	end
	
	return level, locals
end

function locals (co)
	return next_local, co, 0
end

local nice = "foo"

function print_locals ()
	for level, ltable in locals() do
		print(level)
	
		for _, row in ipairs(ltable) do
			print(row.name, row.value)
		end
	end
end

function test ()
	local x = 1
	local y = 2
	local z = 3
	
	--[[
	for level, ltable in locals() do
		print(level)
	
		for _, row in ipairs(ltable) do
			print(row.name, row.value)
		end
	end
	--]]
	print_locals() -- if you're going to use this, you may have to pass 'level' as a parameter, tbc.
	print()
end

function second_trip ()
	local h = "baytown"
	
	coroutine.yield()
end

function travel ()
	local x = 0
	local w = nice
	second_trip ()
end

test()
co = coroutine.create(travel)

coroutine.resume(co)

for level, ltable in locals(co) do
	print(level)
	
	for _, row in ipairs(ltable) do
		print(row.name, row.value)
	end
end

-- wow!  tbc - finish for upvalues, adapt for coroutines, see if you can use this to
-- solve ex25-3.