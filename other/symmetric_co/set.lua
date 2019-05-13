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
	-- Impossible to add an existing element twice.
	Sizes[self] = self[thing] and Sizes[self] or Sizes[self] + 1
	
	self[thing] = true
end

function Set:remove (thing)
	-- Impossible to diminish a set by an element that isn't there.
	-- Checking the immediate parent generation is sufficient, since we want to remove
	-- elements only from the current child generation; if a grandparent+ has the element,
	-- then 'getmetatable(self)[thing]' will still trigger on that.
	Sizes[self] = self[thing] and (not getmetatable(self)[thing]) and Sizes[self] - 1 or Sizes[self]
	
	--Sizes[self] = (new_size >= 0) and new_size or 0
	
	self[thing] = nil
end

-- Size will also include inherited elements.
function Set:size ()
	-- Need all metatables, not just the immediate parent!
	
	print("for this table:")
	for k,v in pairs(getmetatable(self)) do
		if k == "size" then print(k,v) end
	end

	--[[
	print("again:")
	for k,v in pairs(self) do
		if k == "size" then print(k,v) end
	end
	--]]
	
	local more 
	if getmetatable(self).size then
		more = getmetatable(self):size()
	else
		more = 0
	end
	
	--return Sizes[self] + getmetatable(self):size()
	return Sizes[self] + more
end

-- Displays original elements, not inherited ones.
function Set:display_removable ()
	for item in pairs(self) do
		io.write(item, " ")
	end
	
	io.write "\n"
end

-- Tempting to return 'Set:new()', but we want to be able to make original, empty sets,
-- and not just clone existing ones; we want to be able to use all of them to the fullest.
return Set