--[[
	Exercise 23.4
	
	Explain the output of the program in Listing 23.3.
]]

function print_cols (header, col1, col2)
	io.write(string.format("%-25s%-10s%10s\n", header, tostring(col1), tostring(col2))) 
end

local count = 0

local mt = {__gc = function () count = count - 1 end}
local a = {}

-- Show memory usage before doing any allocation and such.
print_cols("before incrementing count:", collectgarbage("count") * 1024, "count not defined")

-- Does incrementing 'count' affect memory usage?
for i = 1, 10000 do
	count = count + 1
end

-- Apparently, not.
print_cols("before row allocation:", collectgarbage("count") * 1024, count)

-- Now, this certainly will.
for i = 1, 10000 do
	local row = {}
	setmetatable(row, mt) -- comment this out to prevent resurrection.
	a[i] = row
end


-- It doesn't look like anything is collectible at this point, but leave it in
-- anyway.
collectgarbage() 

-- Show us the initial value of count, and what amount of memory in bytes
-- Lua is currently using.
print_cols("initial:", collectgarbage("count") * 1024, count)

-- Eliminate the reference 'a', thus losing all of its rows to oblivion.
a = nil

-- Now collect those lost references.
collectgarbage()
print_cols("after first collect:", collectgarbage("count") * 1024, count)

--[[
	At this point, all the dead references in 'a' have been collected,
	so the number of bytes in use has gone down, and count is now 0.
	But - something is weird. Used memory started out at, say 26669.0
	bytes, but we're still at 585079.0 bytes of memory used. So, it
	looks like the rows had been resurrected to call their finalizers
	(see below).
]]

collectgarbage()
print_cols("after second collect", collectgarbage("count") * 1024, count)

-- Now, the objects that were finalized during the first call have been
-- deleted, and our memory is where it should be at, not quite reaching
-- 30K.

--[[
	Output with finalizers (setting the metatable of each row):
	
	before incrementing count:29396.0   count not defined
	before row allocation:   29579.0        10000
	initial:                 848302.0       10000
	after first collect:     586174.0           0
	after second collect     26174.0            0
	
	Output without finalizers (don't set the metatable for each row;
	comment that line out):
	
	before incrementing count:29348.0   count not defined
	before row allocation:   29531.0        10000
	initial:                 848766.0       10000
	after first collect:     26126.0        10000
	after second collect     26126.0        10000
	
	Note that we've collected all lost objects after the first collect; 
	no row had to be resurrected to call a finalizer (note also, of course,
	that 'count' hasn't been decremented, since it was the finalizer that
	did that.)
]]