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

-- 'flevel' is an offset for functions that call 'locals' to 
-- inspect a regular function's variables (from the inside).
function locals (co, flevel)
	return next_local, co, flevel or 0
end

local nice = "foo"

--[[
function print_locals (co)
	local slevel = 1
	
	for level, ltable in locals(co, slevel) do
		print("LEVEL: ", level - slevel)

		for _, row in ipairs(ltable) do
			print(row.name, row.value)
		end
	end
	
	print()
end
--]]

function tlocals (co)
	local slevel = 1
	local tl = {}
	
	for level, ltable in locals(co, slevel) do
		tl[level - slevel] = ltable
	end
	
	return tl
end

function test ()
	local x = 1
	local y = 2
	local z = 3

	local tl = tlocals()
	
	for _, set in ipairs(tl) do
		for i,row in ipairs(set) do
			print(i,row.name, row.value)
		end
	end

	--print_locals()
	--[[
	--local idx = 1
	for level, ltable in locals(nil, 2) do
		print("LEVEL: ", level)	
		for _, row in ipairs(ltable) do
			print(row.name, row.value)
		end
		--main_lt[idx] = ltable
	end
	print()
	--]]
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
-- you could, if you wanted to, write an iterator that already accumulated values into a table, into
-- its "invariant state". You could write a simple mock iterator to try this out, e.g. to accumulate
-- a range of numbers into a table... but the table would be always returned on each loop. - good idea???
-- also, you could wrap ltable in an object, such that you could do 
-- for name, value in ltable:entries() do ...