--[[
	Exercise 16.2
	
	Write a function 'multiload' that generalizes 'loadwithprefix' by
receiving a list of readers, as in the following example:

f = multiload("local x = 10;",
				io.lines("temp", "*L"),
				" print(x)")
				
In the above example, 'multiload' should load a chunk equivalent to the 
concatenation of the string "local ...", the contents of the 'temp' file,
and the string "print(x)". Like 'loadwithprefix', from the previous exercise,
'multiload' should not actually concatenate anything.
]]

function multiload (...)
	
	local chunks = {...}
	local queue = {}
	
	for _, chunk in ipairs(chunks) do
		if type(chunk) == "string" then
			queue[#queue + 1] = chunk
		elseif type(chunk) == "function" then
			for block in chunk do
				queue[#queue + 1] = block
			end
		else 
			error("invalid chunk type: " .. type(chunk), 2)
		end
	end
	
	local i = 0
	
	return load(function ()
		i = i + 1
		return queue[i]
	end)
end

function use_this (...)

	F = assert(multiload(...))
	F()	
end

use_this("local x = 10;", io.lines("tests16-2/test1.lua"), " print(x)")       
use_this("local key = 2;", 
	io.lines("tests16-2/test2.lua", "L"), " print(keys[key])")