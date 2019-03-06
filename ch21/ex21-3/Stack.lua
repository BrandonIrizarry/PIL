--[[
	Exercise 21.3
	
	Reimplement your Stack class using a dual representation.
]]

local contents = {}

local Stack = {}

function Stack:new (seq)

	local stack = {}
	contents[stack] = seq or {}
	
	self.__index = self
	
	self.__tostring = function ()
		local buffer = {}
		for i = 1, #contents[stack] do
			buffer[#buffer + 1] = contents[stack][i]
		end
		
		return (#buffer > 0) and table.concat(buffer, " ") or "<empty>"
	end
			
	setmetatable(stack, self)
	
	return stack
end

function Stack:push (item)
	table.insert(contents[self], item)
end

function Stack:pop ()
	return table.remove(contents[self])
end

function Stack:top ()
	local top_index = #contents[self]
	return contents.self[top_index]
end

function Stack:isempty ()
	return #contents[self] == 0
end

return Stack:new()