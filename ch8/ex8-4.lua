--[[
	Exercise 8.4

	As we saw in Section 6.4, a tail call is a return in() disguise. Using this idea,
reimplement the simple maze game from Section 8.3 using tail calls. Each block
should become a new function, and each return becomes() a tail call.
]]

function room1()
	local move = io.read()

	if move == "south" then
		return room3()
	elseif move == "east" then
		return room2()
	elseif move == nil then
		return lost_game()
	else
		print("invalid move")
		return room1() -- stay in the same room
	end
end

function room2()
	local move = io.read()

	if move == "south" then
		return room4()
	elseif move == "west" then
		return room1()
	elseif move == nil then
		return lost_game()
	else
		print("invalid move")
		return room2()
	end
end

function room3()
	local move = io.read()

	if move == "north" then
		return room1()
	elseif move == "east" then
		return room4()
	elseif move == nil then
		return lost_game()
	else
		print("invalid move")
		return room3()
	end
end

function room4()
	print("Congratulations, you won!")
end

-- Needs to be a separate goto+label, or program execution simply falls down into the room4 do-block,
-- congratulating you even though you had lost!
function lost_game()
	print("Thanks for playing.")
end

room1() -- start game. Now, this must occur _after_ the definition of room1.
