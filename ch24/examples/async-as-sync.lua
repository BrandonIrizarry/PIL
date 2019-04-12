local lib = require "async-lib"

-- Save created callbacks in this table.
local callback_memo = {}

function run (code)
	local co = coroutine.create(function ()
		code()
		lib.stop()		-- finish event-loop when done
		return "done"
	end)
	
	lib.show_queue()
	print("start!", coroutine.resume(co))				-- start the coroutine
	lib.show_queue()
	lib.runloop()		-- start event loop
end

-- Returns the callback associated with this coroutine.
-- If the callback doesn't exist yet, then define and store it.

function memo_callback (co)
	-- There's only one function we need to memo.
	local callback = callback_memo[1]
	
	if callback == nil then
		--print("not yet.")
		callback = function (line) return coroutine.resume(co, line) end
		callback_memo[1] = callback
	else
		--print("finally.", collectgarbage("count") * 1024)
	end
	
	return callback
end


function putline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)
	lib.writeline(stream, line, callback)
	coroutine.yield("W")
end

function getline (stream)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)	
	lib.readline(stream, callback)
	local line = coroutine.yield("R")
	
	return line
end

function lines (stream)
	return function ()
		return getline(stream)
	end
end


return {run = run, putline = putline, getline = getline, lines = lines}