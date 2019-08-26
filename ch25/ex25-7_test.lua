local B = require "ex25-7"

local function test1 ()
	local a = 2
	local b = 3
	
	local function inside ()
		local x = 'a'
		local y = 'b'
	end
	
	inside()
end

local function test2 ()
	local x = 0
	local y = 1
	
	for i = 1, 10 do
	end
end

local function test3 ()
	local _ = nil
	local _ = nil
	local _ = nil
end


--local h2 = B.setbreakpoint(test2, 1, "test2:start_of_func")
--local h1 = B.setbreakpoint(test2, 4, "test2:start_of_loop")
local h3 = B.setbreakpoint(test2, 2, "whatisx?")
local h4 = B.setbreakpoint(test2, 3, "whatisx?")
B.init()

test1()
test2()
test3()
test2()
B.removebreakpoint(h1)

