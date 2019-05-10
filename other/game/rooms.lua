function throne_room ()
	local has_ruby = false
	
	while true do
		print([[
The king says, "Find me a ruby in these rooms, and you will be free."
You see stairs that lead to another room.
	1. Give the king the ruby.
	2. Go down the stairs.]])

		repeat
			print("What do you do (1,2)")
			local ans = io.read("n")
		until (ans == 1) or (ans == 2)
		
		if ans == 1 then 
			transfer(win_game, has_ruby)
		else
			has_ruby = transfer(door_room)
		end
	end
end

function win_game (has_ruby)
	while true do
		print("So, you say you have the ruby...")
		if has_ruby then
			print("Congratulations, you win! You are free.")
			
		else
			transfer(throne_room)
		end
	

function door_room ()
	while true do
		print([[
You see a locked door, and another, unrestricted passage]])

	repeat
		print("Go through the passage (1) ?")
		local ans = io.read("1")
	until ans == "y"
	

	