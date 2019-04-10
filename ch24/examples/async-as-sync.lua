local lib = require "async-lib"

-- Save created callbacks in this table.
local callback_memo = {}

function run (code)
	local co = coroutine.wrap(function ()
		code()
		lib.stop()		-- finish event-loop when done
	end)
	
	co()				-- start the coroutine
	lib.runloop()		-- start event loop
end

-- Returns the callback associated with this coroutine.
-- If the callback doesn't exist yet, then define and store it.

function memo_callback (co)
	-- There's only one function we need to memo.
	local callback = callback_memo[1]
	
	if callback == nil then
		print("not yet.")
		callback = function (line) coroutine.resume(co, line) end
		callback_memo[1] = callback
	else
		print("finally.", collectgarbage("count") * 1024)
	end
	
	return callback
end

function putline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)
	--local callback = function () coroutine.resume(co) end
	--print("mem-putline: ", collectgarbage("count") * 1024)
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co)	
	--local callback = function (line) coroutine.resume(co, line) end
	--print("mem-getline: ", collectgarbage("count") * 1024)
	lib.readline(stream, callback)
	local line = coroutine.yield()
	
	return line
end


return {run = run, putline = putline, getline = getline}