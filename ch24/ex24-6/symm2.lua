--[[
	An alternate solution to Exercise 24.6
	
	If a symmetric coroutine returns, a status of 'false' is returned,
and an error is raised.
]]


local symm = {}

-- The creator function must be modified to flag when coroutines return.
-- This is illegal; symmetric coroutines are subordinate only to the dispatcher.
function symm.create (fn)
	local g = function (val)
		fn(val)
		return false
	end
	
	return coroutine.create(g)
end

-- The dispatcher.
function symm.main (new_co, val)

	local status
	
	while true do		
		if new_co == true then
			return val
		elseif new_co == false then
			error("coroutine returned")
		else
			print(status, new_co, val)
			status, new_co, val  = coroutine.resume(new_co, val)	
		end
	end
end

-- The 'transfer' function.
function symm.transfer(new_co, val)
	return coroutine.yield(new_co, val)
end


return symm

