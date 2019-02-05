--[[
	Exercise 16.1

	Frequently, it is useful to add some prefix to a chunk of code
when loading it. (We saw an example previously in this chapter, where
we prefixed a 'return' to a expression being loaded.) Write a function 'loadwithprefix' that works like 'load', except that it adds its extra first argument (a string) as a prefix to the chunk being loaded.  
	Like the original 'load', 'loadwithprefix' should accept chunks represented both as strings and as reader functions. Even in the case that the original chunk is a string, 'loadwithprefix' should not actually concatenate the prefix with the chunk. Instead, it should call 'load' with the proper reader function that first returns the prefix and then returns the original chunk.
]]

function loadwithprefix (prefix, chunk)
	
	if prefix == "" then
		error("prefix can't be the empty string", 2)
	end
	
	local queue = {prefix}
	
	if type(chunk) == "string" then
		queue[#queue + 1] = chunk
	elseif type(chunk) == "function" then
		for block in chunk do
			queue[#queue + 1] = block
		end
	else 
		error("invalid chunk type: " .. type(chunk), 2)
	end
	
	local i = 0
	
	return load(function ()
		i = i + 1
		return queue[i]
	end)
end


print(assert(loadwithprefix("return ", "5"))())

function use_file(prefix, filename)
	local F = assert(loadwithprefix(prefix, io.lines(filename, "L")))
	print(F())
end

use_file("a = {}", "test16-1.lua")


