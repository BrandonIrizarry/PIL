local lib = require "async-lib"

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
	
	local callback =
		function ()
			coroutine.resume(co)
		end
	
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream, line)
	local co = coroutine.running()		-- the calling coroutine
	
	local callback = 
		function (line)
			coroutine.resume(co, line)
		end
		
	lib.readline(stream, callback)
	local line = coroutine.yield()
	
	return line
end

return {run = run, putline = putline, getline = getline}