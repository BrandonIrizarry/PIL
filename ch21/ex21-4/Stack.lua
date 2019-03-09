--[[
	--Fri 08 Mar 2019 09:08:03 PM EST

	An implementation of a stack using a protector table.
This table ensures that only object methods can alter object state.
	A __tostring metamethod is also defined. That's really most of
the complexity involved here!
	I've made all data global within the module itself, to aid in 
terminal debugging.
]]
	
P = {}

function protect (T)
	local proxy = {}
	P[proxy] = T
	
	return proxy
end

s = {contents = {}}
s = protect(s) 

local base_mt = {}

base_mt.__tostring = function (child)
	local buffer = {}
	
	for _, item in ipairs(P[child].contents) do
		table.insert(buffer, item)
	end
	
	table.insert(buffer, "\nok")
	
	return table.concat(buffer, " ")
end

setmetatable(s, base_mt)

function s:new ()
	local stack = {contents = {}}
	stack = protect(stack)
	
	self.__index = self
	
	self.__tostring = function (child)
		local buffer = {}
	
		for _, item in ipairs(P[child].contents) do
			table.insert(buffer, item)
		end
		
		table.insert(buffer, "\nok")
		
		return table.concat(buffer, ", ")
	end

	setmetatable(stack, self)
	
	return stack
end

function s:push (item)
	table.insert(P[self].contents, item)
end

function s:pop ()
	return table.remove(P[self].contents)
end

function s:top ()
	local C = P[self].contents
	return C[#C]
end

function s:isempty ()
	return #P[self].contents == 0
end

-- Returning a _child_ of a stack hides the methods.
return s:new()