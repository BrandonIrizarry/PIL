--[[
	Exercise 21.1
	
	Implement a class Stack, with methods push, pop, top, and isempty.
]]


function reload ()
	package.loaded["/home/brandon/PIL/ch21/ex21-1.lua"] = nil
	dofile("/home/brandon/PIL/ch21/ex21-1.lua")
end


local Stack = {}

function Stack:new (seq)

	-- Make a new stack from scratch, and transfer the 
	-- original sequence into the stack as the stack's contents
	-- (as opposed to its methods, and other "administrative" fields.)
	local stack = {contents = seq or {}} 
	
	self.__index = self
	
	self.__tostring = function ()
		local buffer = {}
		for i = 1, #stack.contents do
			buffer[#buffer + 1] = stack.contents[i]
		end
		
		return table.concat(buffer, " ")
	end
			
	setmetatable(stack, self)
	
	return stack
end

function Stack:push (item)
	table.insert(self.contents, item)
end

function Stack:pop ()
	return table.remove(self.contents)
end

function Stack:top ()
	return self.contents[#self.contents]
end

function Stack:isempty ()
	return #self.contents == 0
end

return Stack
