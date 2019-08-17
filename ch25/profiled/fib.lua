--[[
	Profile 'fib'.
	
	Note that the dummy function 'recurred' sends information to the
profiler about how many calls to 'fib' are non-terminal!

tbc -- non-terminal counter still is at zero?
see if you can prove that memoization brings the counts down :)
]]

local non_terminal = 0

local function recurred () non_terminal  = non_terminal + 1 end


local function fib (n)
	if n == 0 then return 0 end
	if n == 1 then return 1 end
	
	recurred()
	return fib(n - 1) + fib(n - 2)
end

print("non terminal:", non_terminal)
fib(3)