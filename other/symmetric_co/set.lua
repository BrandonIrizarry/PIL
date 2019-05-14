local Set = {collection = {}, size = 0}

function Set:new (seq)

	seq = seq or {}
	local set = {collection = {}, size = #seq + self.size}
	
	-- Copy parent's items into the child
	for item in pairs(self.collection) do
		set.collection[item] = true
	end
	
	-- Copy any additional items, given by a sequence, into the child
	for _, item in ipairs(seq) do
		self.collection[item] = true
	end
	
	-- Set up inheritance just in case.
	self.__index = self
	return setmetatable(set, self)
end
	
function Set:add (item)
	self.size = self.collection[item] and self.size or self.size + 1
	self.collection[item] = true
end

function Set:remove (item)
	self.size = self.collection[item] and self.size - 1 or self.size
	self.collection[item] = nil
end

function Set:obj_print ()
	for item in pairs(self) do
		io.write(item, " ")
	end
	
	io.write "\n"
end


return Set

	