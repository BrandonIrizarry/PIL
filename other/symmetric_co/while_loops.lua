
Room = {}

function Room:new (items)
	self.__index = self
	return setmetatable(items or {}, self)
end

function Room:showItems ()
	local count = 0
	
	for item in pairs(self) do
		io.write(item, " ")
		count = count + 1
	end
	
	io.write("\n")
	
	return count
end

function Room:visit ()
	local ans 
	
	repeat
		local size = self:showItems()
		print("What are you taking?")
		ans = io.read()
		coroutine.yield(self[ans])
		self[ans] = nil
	until size == 0
end

TreasureRoom = Room:new(Set:new{"gold", "silver", "ruby", "diamond", "emerald"})
FoodRoom = Room:new(Set:new{"grape", "cherry", "orange", "apple", "pear"})


Room.visit = coroutine.create(Room.visit)

function run (room)
	coroutine.resume(room.visit, room)
end

-- tbc: you will have to get one item from one room to qualify for an item in another.
-- say, you need the diamond to buy the pear :) That's the only way you can empty the
-- sets. But, you of course need to transfer between the two coroutines, so let's
-- see if we can ultimately use a symmetric coroutine discipline here, hopefully that 
-- approach makes the most sense.