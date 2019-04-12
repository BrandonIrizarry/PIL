--[[
	Exercise 24.4
	
	Write a line iterator for the coroutine-based libary (Listing 24.5), so that
you can read the file with a for-loop.
]]

--[[
	We've omitted the memoization stuff here to express more clearly the
concepts of the current solution (though I got it to work with memoization
in 'examples/async-as-sync.lua'.)
	Looking at how simple the solution is after thinking about it
for so long... Wow!
]]

local lib = require "examples.async-lib"

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
	
	-- Using the iterator here!
	for line in lines(inp) do
		t[#t + 1] = line
	end
	
	for i = #t, 1, -1 do
		putline(out, t[i] .. "\n")
	end
end

run(reverse_lines)