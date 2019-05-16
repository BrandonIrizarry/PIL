local Bag = {collection = {}}

function Bag:new (raw)

	raw = raw or {}
	local bag = {collection = {}}
	
	-- Copy from the raw bag into the bag
	for item, count in pairs(raw) do
		bag.collection[item] = (bag.collection[item] or 0) + count
	end
	
	-- Copy from the parent bag into the child bag
	for item, count in pairs(self.collection) do
		bag.collection[item] = (bag.collection[item] or 0) + count
	end
	
	self.__index = self
	return setmetatable(bag, self)	
end

function Bag:add (item)
	self.collection[item] = (self.collection[item] or 0) + 1
end

function Bag:remove (item)
	local count = self.collection[item]
	self.collection[item] = (count and count > 1) and count - 1 or nil
end

function Bag:_print ()
	for item, count in pairs(self.collection) do
		io.write(item, " ", count, "; ")
	end
	
	io.write "\n"
end

return Bag