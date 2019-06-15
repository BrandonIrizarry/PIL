
local symm = require "symm"

local flowers = {"rose", "daisy", "violet", "peony", "sunflower"}
local fruits = {"apple", "orange", "lemon", "banana", "grape"}
local basket = {}
local ans

function printf (fmt, ...)
	return print(string.format(fmt, ...))
end

function get_flowers (bi)
	
	for _, flower in ipairs(flowers) do
		printf("Take the current flower '%s'?", flower)
		ans = io.read()
		
		if ans == 'y' then
			printf("Taking '%s'", flower)
			basket[bi] = flower
			bi = bi + 1 
		elseif ans == 'n' then
			print("Switching to fruits, then...")
			bi = symm.transfer(get_fruits, bi)
		elseif ans == nil then
			print("No more collection? OK.")
			symm.transfer(true, bi)
		elseif ans == 'q' then
			return 42 -- trigger an 'illegal return' error.
		else
			print("Invalid selection")
		end
	end
	
	symm.transfer(true, bi)
end

function get_fruits (bi)
	
	for _, fruit in ipairs(fruits) do
		printf("Take the current fruit '%s'?", fruit)
		ans = io.read()
		
		if ans == 'y' then
			printf("Taking '%s'", fruit)
			basket[bi] = fruit
			bi = bi + 1 -- key step
		elseif ans == 'n' then
			print("Switching to flowers, then...")
			bi = symm.transfer(get_flowers, bi)
		elseif ans == nil then
			print("No more collection? OK.")
			symm.transfer(true, bi) 		
		else 			
			print("Invalid selection")
		end
	end
	
	symm.transfer(true, bi) 
end



get_fruits = symm.create(get_fruits)
get_flowers = symm.create(get_flowers) 	
print(symm.main(get_fruits, 1))
print(symm.main(get_fruits, 1))
--local status, val = symm.main(get_fruits, 1)
--[[
-- If the second time doesn't work, rewind that coroutine, and retry.
if status == false then
	print(symm.main(symm.create(val), 1))
end
--]]