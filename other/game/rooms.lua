--[[
	Implement something in the spirit of Learn Python the Hard Way by Zed Shaw -
a simple game where we traverse some rooms, and complete some mission to win the
game.
	The goal is, eventually, to see if implementing the game using any sort of
coroutine discipline (preferably symmetric) simplifies things, or contributes
anything to the logic (e.g., lets our game use more game-play features.)
]]

Room = {}

-- Let 'items' be a Lua set.
function Room:new (items)

	self.__index = self
	return setmetatable(items or {}, self)
end


ThroneRoom = Room:new()
DoorRoom = Room:new()
KeyRoom = Room:new({key=true})
RubyRoom = Room:new({ruby=true})

function query (limit)
	assert((math.type(limit) == "integer") and (limit > 0))
		
	local ans

	repeat
		print("What do you do?")
		ans = math.tointeger(io.read())
		
		-- Type '0' at any prompt to exit the game.
		if ans == 0 then os.exit() end
		
	until (ans ~= nil) and (ans > 0) and (ans <= limit) 
	
	return ans 
end

function ThroneRoom:action ()
	print([[
The king says, "Find me a ruby in these rooms, and you will be free."
You see stairs that lead to another room.
1. Give the king the ruby.
2. Go down the stairs.]])

	local ans = query(2)
	
	if ans == 1 then 
		if RubyRoom.ruby then
			print("You don't have the ruby yet! Keep looking.")
			self:action() -- redo the room.
		else
			print("Congratulations, you won!")
		end
	else
		DoorRoom:action()
	end
end

function DoorRoom:action ()
	print([[
There is a locked door in this room.
There is also an unrestricted passage to another room.
1. Open the door.
2. Go through the passage.
3. Go back to the throne room.]])

	local ans = query(3)
	
	if ans == 1 then
		if not KeyRoom.key then
			print("You unlock the door.")
			RubyRoom:action()
		else
			print("You don't have the key yet.")
			self:action()
		end
	elseif ans == 2 then
		print("You decide to go through the passage.")
		KeyRoom:action()
	else
		print("You head back to the throne room.")
		if RubyRoom.ruby then
			print("Are you sure you aren't missing something?")
		end
		ThroneRoom:action()
	end
end

function KeyRoom:action ()
	print([[
You see a box in the middle of the room. It appears to be open.
1. Open the box
2. Go back through the passage.]])
	
	local ans = query(2)
	
	if ans == 1 then
		if self.key then
			print("You see a key, and take it.")
			self.key = false
			self:action()
		else
			print("The box is empty.")
			self:action()
		end
	else
		DoorRoom:action()
	end
end

function RubyRoom:action ()
	print([[
You see a box in the middle of the room. It appears to be open.
1. Open the box
2. Go back through the door.]])

	local ans = query(2)
	
	if ans == 1 then
		if self.ruby then 
			print("You see a ruby, and take it.")
			self.ruby = false
			self:action()
		else
			print("The box is empty.")
			self:action()
		end
	else
		DoorRoom:action()
	end
end

ThroneRoom:action()

