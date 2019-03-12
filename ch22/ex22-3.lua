--[[
	Exercise 22.3
	
	Explain in detail what happens in the following program and what it will
print:

local print = print
function foo (_ENV, a)
	print(a + b)
end

foo({b = 14}, 12)
foo({b = 10}, 1)
--]]

-- Again, as in algebra class, simplify:

function altered ()
	local _print = _ENV.print

	function foo (_ENV, a)
		_print(a + _ENV.b)
	end

	foo({b = 14}, 12)
	foo({b = 10}, 1)
end

function original ()
	local print = print
	function foo (_ENV, a)
		print(a + b)
	end

	foo({b = 14}, 12)
	foo({b = 10}, 1)
end

-- Sanity check, to see if our simplifications didn't alter anything.
altered()
original()

--[[
	Now it's clear what everything's doing: passing in an _ENV that defines
b determines the value of the sum (_ENV's value is governed by Lua's 
visibility rules.)
]]