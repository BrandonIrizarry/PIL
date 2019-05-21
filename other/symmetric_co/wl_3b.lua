--[[
	Dispatcher method for the symmetric coroutines.
	Note the analogy to "goto" - I have a 'finish' 
	coroutine that acts as a colophon to all the functionality.
	That last coroutine returns 'true', signaling the end
	of the dispatch loop.

	The trick is to now cast this in the form of a 'transfer' function;
	though, in my opinion, this would work fine for whatever application
	would benefit from a 'transfer' function, so I'm keeping it around.
	
	Symmetric coroutines must not be able to exhaust without first going 
	to the 'finish' coroutine; the user must see the message, "Function
	'main' reports: we are done."
	
	If any coroutine returns 'true', then the dispatch loop finishes;
	'finish' doesn't need to be reached. If coroutines return something
	other than a thread, they're finished by definition. However, that
	feels too restrictive, possibly even a leaky abstraction.
	
	The "error" version of 'create', though, might help here.
	So far, we got rid of "finish". The goal is to create a self-contained module.
	
	We just managed to self-contain the "return true" feature! The point, ultimately,
	is to approximate, if not equal, the paper's implementation, but going step by step,
	so we understand everything, and aren't just blindly copying.
]]

symm = {}

function symm.create (fn)
	local g = function (val)
		fn(val)
		error("Coroutine ended without transfering to main program")
	end
	
	return coroutine.create(g)
end

symm.finish = nil
symm.current = nil
	

function symm.main (new_co, val)
	local status

	while true do
		status, new_co, val = coroutine.resume(new_co, val)
		--print(status, new_co, type(new_co), new_co == finish) -- debug
		
		if new_co == symm.finish then
			return symm.finish()
		end
	end
end


function symm.transfer(new_co, val)
	symm.current = new_co -- this is what we'll work on in the next iteration. tbc.
	return coroutine.yield(new_co, val)
end

-- End symm module (symm == symmetric coroutines.)
-------------------------------------------------------------------------------

-- Begin user program.

local flowers = {"rose", "daisy", "violet", "peony", "sunflower"}
local fruits = {"apple", "orange", "lemon", "banana", "grape"}
local basket = {}
local ans

function printf (fmt, ...)
	return print(string.format(fmt, ...))
end

symm.finish = function (bi)
	print("This is the final result:")
	
	for _, thing in ipairs(basket) do
		io.write(thing, " ")
	end
	
	io.write("\n")
			
	print("Tada! The end.")
    
	return bi
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
			symm.transfer(symm.finish, bi)
		else
			print("Invalid selection")
		end
	end
	
	symm.transfer(symm.finish, bi)
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
			symm.transfer(symm.finish, bi) 		
		else 			
			print("Invalid selection")
		end
	end
	
	symm.transfer(symm.finish, bi) 
end



get_fruits = symm.create(get_fruits)
get_flowers = symm.create(get_flowers) 	
symm.main(get_fruits, 1)

--[[
function print_A (str)
	local ans
	
	while true do
		io.write("Add an 'A'?")
		ans = io.read()
		
		if ans == 'y' then
			print("Added an 'A'")
			str = str .. "A"
		elseif ans == 'n' then
			print("Transferring to 'B'")
			str = coroutine.yield(print_B, str)
		elseif ans == nil then
			print("will report final result then...")
			coroutine.yield(finish, str)
		else
			print("Invalid selection")
		end
	end
end

function print_B (str)
	local ans

	while true do
		io.write("Add a 'B'?")
		ans = io.read()
		
		if ans == 'y' then
			print("Added a 'B'")
			str = str .. "B"
		elseif ans == 'n' then
			print("Transferring to 'A'")
			str = coroutine.yield(print_A, str)
		elseif ans == nil then
			print("Will report final result then...")
			coroutine.yield(finish, str)
		else
			print("Invalid selection")
		end
	end
end

function finish (str)
	print("This is the final result:")
	print(str)
	print("Tada! The end.")
	
	return true
end

print_A = coroutine.create(print_A)
print_B = coroutine.create(print_B)
finish = coroutine.create(finish)
	
main(print_A)
--]]

--]=]