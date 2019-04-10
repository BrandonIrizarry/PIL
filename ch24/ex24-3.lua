--[[
	Exercise 24.3
	
	In Listing 24.5, both the functions getline and putline create a new closure
each time they are called. Use memorization to avoid this waste.
]]

local lib = require "examples.async-lib"

-- Save created callbacks in this table.
local callback_memo = {}


-- Returns the callback associated with this coroutine.
-- If the callback doesn't exist yet, then define and store it.
function memo_callback (co)

	-- I found it difficult to independently _name_ the callback,
	-- so I just use array index 1 as the function's "name".
	-- I guess I'm still quite green at this. :)
	local callback = callback_memo[1]
	
	if callback == nil then
		print("not yet.")
		callback = function (line) coroutine.resume(co, line) end
		callback_memo[1] = callback
	else
		-- Just examine how memory is growing as commands are run
		-- we wanted to see how much memory we were saving by
		-- memorizing the closures, but it doesn't look like much,
		-- if anything.
		print(callback_memo[1], collectgarbage("count") * 1024)
	end
	
	return callback
end

function run (code)
	local co = coroutine.wrap(function ()
		code()
		lib.stop()		-- finish event-loop when done
	end)
	
	co()				-- start the coroutine
	lib.runloop()		-- start event loop
end



function putline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)	
	lib.readline(stream, callback)
	local line = coroutine.yield()
	
	return line
end

-- Do the usual test.
function reverse_lines ()
	local LINES = {}
	local inp = io.input()
	local out = io.output()
	
	while true do
		local line = getline(inp)
		if not line then break end
		LINES[#LINES + 1] = line
	end
	
	for i = #LINES, 1, -1 do
		putline(out, LINES[i] .. "\n")
	end
end

run(reverse_lines)