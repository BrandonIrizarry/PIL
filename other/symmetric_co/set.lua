local Set = {}
Sizes = {} -- use a dual representation for set sizes.

-- Just initialize the size of the primordial Set to 0 - 
-- otherwise, only children would have sizes (see circa line 15),
-- and therefore the first set you use would throw an error upon
-- invoking 'size'.
Sizes[Set] = 0

function Set:new (seq)
	
	local set = {}
	
	seq = seq or {} -- if no sequence is given, naturally assume an empty one.
	
	-- Note there is no mention of Sizes[self] (see circa line 6)
	Sizes[set] = #seq
	
	-- From the book.
	for _, thing in ipairs(seq) do
		set[thing] = true
	end
		
	-- The new 'set' will inherit fields from the parent set.
	self.__index = self
	return setmetatable(set, self)
end

function Set:add (thing)

	Sizes[self] = self[thing] and Sizes[self] or Sizes[self] + 1
	self[thing] = true
end

function Set:remove (thing)
	
	-- Set sizes can't go below 0.
	local new_size = self[thing] and Sizes[self] - 1 or Sizes[self]
	Sizes[self] = (new_size >= 0) and new_size or 0 
	
	self[thing] = nil
end

function Set:size ()
	return Sizes[self] + Sizes[getmetatable(self)]
end

-- We want a new set right away.
return Set:new()