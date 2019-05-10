local coro = {}

coro.main = function () end
coro.current = coro.main

-- function to create a new coroutine
function coro.create (f)
	return coroutine.wrap(function (val)
		f(val)
		
		-- Coroutine has terminated without an explicit transfer of control.
		error("coroutine ended")
	end)
end
	
-- function to transfer control to a coroutine
function coro.transfer (co, val)
	if coro.current == coro.main then
		return coroutine.yield(co, val)
	end

	-- dispatching loop
	while true do
		coro.current = co
	
		if co == coro.main then
			return val
		end
		
		co, val = co(val)
	end
end

return coro