--[[
	Exercise 21.2
	
	Implement a class 'StackQueue' as a subclass of 'Stack'. Besides the
inherited methods, add to this class a method 'insertbottom', which inserts
an element at the bottom of the stack. (This method allows us to use objects of 
this class as a queues.)
]]

-- The definition of the original class, Stack.
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
-- End the definition of Stack; let's begin the definition of StackQueue.

local StackQueue = Stack:new()

function StackQueue:insertbottom (item)
	table.insert(self.contents, 1, item)
end

return StackQueue