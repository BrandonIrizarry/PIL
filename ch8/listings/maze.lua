goto room1 -- initial room.

::room1::

do
	local move = io.read()

	if move == "south" then
		goto room3
	elseif move == "east" then
		goto room2
	elseif move == nil then
		goto lost_game
	else
		print("invalid move")
		goto room1 -- stay in the same room
	end
end

::room2::

do
	local move = io.read()

	if move == "south" then
		goto room4
	elseif move == "west" then
		goto room1
	elseif move == nil then
		goto lost_game
	else
		print("invalid move")
		goto room2
	end
end

::room3::

do
	local move = io.read()

	if move == "north" then
		goto room1
	elseif move == "east" then
		goto room4
	elseif move == nil then
		goto lost_game
	else
		print("invalid move")
		goto room3
	end
end

::room4::

do
	print("Congratulations, you won!")
end

-- Needs to be a separate goto+label, or program execution simply falls down into the room4 do-block,
-- congratulating you even though you had lost!
::lost_game::

do
	print("Sorry, try again.")
end
