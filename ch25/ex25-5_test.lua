local debug_lex = require "ex25-5"

local nice = "I am a nice upvalue."

a = 9
function test ()
	local x, y, z = 0, 1, 2
	local w = nice
	local q = a
	
	debug_lex("flevel_debug")
	debug_lex("fd_confirm_changes")
end

test()

--debug_lex("fd_check_global")

function test2 ()
	for i = 1, 3 do
		io.write("\n")
		debug_lex()
		--io.write("\n")
	end
end

test2()

--[[
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
]]