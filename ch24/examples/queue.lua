
local Queue = {}

function Queue:new ()
	self.__index = self
	return setmetatable({first = 0, last = -1}, self)
end

function Queue:empty ()
	return self.first > self.last
end

-- Was 'pushLast'
function Queue:push (value)
	local last = self.last + 1
	self.last = last
	self[last] = value
end

-- Was 'popFirst'
function Queue:pop ()
	local first = self.first
	if self:empty() then error("list is empty") end
	local value = self[first]
	self[first] = nil -- to allow garbage collection
	self.first = first + 1
	
	return value
end

function Queue:display ()
	if self:empty() then error("list is empty") end
	
	for i = self.first, self.last do
		io.write(self[i], " ")
	end
	io.write("\n")
end



return Queue