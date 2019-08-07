--[[
	Exercise 25.3
	
	Write a version of 'getvarvalue' (Listing 25.1) that returns a table with
all variables that are visible at the calling function. (The returned table should
not include environmental variables; instead, it should inherit them from the 
original environment.
]]


function next_local (co)
	for level = 1, math.huge do
		local valid
		if co then
			valid = debug.getinfo(co, level)
		else
			valid = debug.getinfo(level + 2)
		end
		if not valid then break end
		
		for idx = 1, math.huge do
			local name, value 
			if co then
				name, value = debug.getlocal(co, level, idx)
			else
				name, value = debug.getlocal(level + 2, idx)
			end
			if not name then break end
			
			coroutine.yield(name, value)
		end
	end
end

function locals ()
	return coroutine.wrap(function (co) next_local(co) end)
end

function test ()
	local x = 1
	local y = 2
	local z = 3
	
	print(debug.getlocal(1, 2))
	
	for n,v in locals() do
		print(n,v)
	end
end	
	
test()