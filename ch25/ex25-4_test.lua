local debug_lex = require "ex25-4"

local nice = "I am a nice upvalue."

function test ()
	local x = 0
	local y = 1
	local z = 2
	local w = nice
	
	debug_lex("flevel_debug")
end

test()


function cave ()
	local inside = "inside the cave"
	coroutine.yield()
end

function spelunker ()
	local top = "just outside the cave"
	coroutine.yield()
	cave()
end


local co = coroutine.create(spelunker)

local status1, result1 = coroutine.resume(co)

if status1 then
	debug_lex("coroutine_debug", co)
else
	print(result1)
end
