local lib = require "async-lib"

function run (code)
	local co = coroutine.create(function ()
		code()
		lib.stop()
	end)
	
	coroutine.resume(co)
	lib.runloop()
end


function putline (stream, line)
	local co = coroutine.running()
	local callback = function () coroutine.resume(co) end
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream)
	local co = coroutine.running()
	local callback = function (l) coroutine.resume(co, l) end
	lib.readline(stream, callback)
	local line = coroutine.yield()
	return line
end

function lines (stream)
	return function ()
		return getline(stream)
	end
end

function reverse_lines ()
	local t = {}
	local inp = io.input()
	local out = io.output()
	
	for line in lines(inp) do
		t[#t + 1] = line
	end
	
	for i = #t, 1, -1 do
		putline(out, t[i] .. "\n")
	end
end

run(reverse_lines)