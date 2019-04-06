-- Returns a coroutine whose job is to read a user-inputted line,
-- and yield on that line.
function producer ()
	return coroutine.create(function ()
		while true do
			coroutine.yield(io.read())
		end
	end)
end

-- Returns a coroutine whose job is to resume the line-reading
-- coroutine, and yield on a pretty-printed version of the line.
function filter (prod)
	return coroutine.create(function ()
	
		-- We're going to output lines with line numbers.
		for line = 1, math.huge do
			local _, raw_line = coroutine.resume(prod)
			
			-- Yield on the pretty-printed line.
			coroutine.yield(string.format("%5d %s", line, raw_line))
		end
	end)
end

-- Upon invocation, resume the pretty-printing coroutine ad nauseam.
function consumer (prod)
	while true do
		local _, x = coroutine.resume(prod)		-- get new value
		io.write(x, "\n")			-- consume new value
	end
end

-- Invoke.
consumer(filter(producer()))
		