local debug_lex = require "ex25-5b"

local nice = "I am a nice upvalue."

a = 9
function test ()
	local x, y, z = 0, 1, 2
	local w = nice
	local q = a
	
	debug_lex("flevel_debug", 1, nil, true)
	debug_lex("fd_confirm_changes")
	test2()
end

function test2 ()
	debug_lex("rw test from test2", 2)
	debug_lex("confirm changes", 2)
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
	debug_lex("coroutine_debug", 1, co)
	debug_lex("coro_confirm", 1, co)
else
	print(result1)
end

local s2, r2 = coroutine.resume(co)

if s2 then
	debug_lex("coroutine_up_one", 2, co)
	debug_lex("coro_confirm", 2, co)
else
	print(r2)
end
