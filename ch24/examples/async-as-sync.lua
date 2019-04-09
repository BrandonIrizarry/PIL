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

-- FIXME! We need to memoize the callbacks, but they're anonymous functions,
-- and so a new, unique one is made each time... have _this_ function 
-- define the callback, since we pass in the coroutine as 'co' anyway... tbc.
function memo_callback (co, fn)
	local c_key = tostring(fn)
	local callback = callback_memo[c_key]
	
	if callback == nil then
		callback = fn
		callback_memo[c_key] = callback
	else
		print("we got it!")
	end
	
	return callback
end

function putline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co, function () coroutine.resume(co) end)
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	local callback = memo_callback(co, function (line) coroutine.resume(co, line) end)	
	lib.readline(stream, callback)
	local line = coroutine.yield()
	
	return line
end


return {run = run, putline = putline, getline = getline}