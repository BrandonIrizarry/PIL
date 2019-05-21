--[[
	This is taken from "Revisiting Coroutines" (Moura, Ierusalimschy, 2004),
with some modifications, and an example.
	I have a feeling there's more than one way to do this, but I like how
the resumer and yielder are written as one function, 'transfer' (I was trying to 
get them to be two separate functions, which in my noobish mind is still a more straightforward
approach!)
--]]

symm = {}

symm.main = nil
symm.current = nil

function symm.create (fn)
	local g = function (val)
		fn(val)
		error("Coroutine ended without transfering to main program")
	end
	
	return coroutine.create(g)
end

function symm.transfer (new_co, val)
	local status
	
	if symm.current ~= symm.main then
		symm.current = new_co
		return coroutine.yield(new_co, val)
	else
		while true do
			symm.current = new_co
			
			if new_co == symm.main then return val end
			status, new_co, val = coroutine.resume(new_co, val)
		end
	end
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
			symm.transfer(symm.main, bi)
		else
			print("Invalid selection")
		end
	end
	
	symm.transfer(symm.main, bi)
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
			symm.transfer(symm.main, bi) 		
		else 			
			print("Invalid selection")
		end
	end
	
	symm.transfer(symm.main, bi) 
end



get_fruits = symm.create(get_fruits)
get_flowers = symm.create(get_flowers) 	

function run_main ()
	print("Welcome to the program. Start?")
	if io.read() == nil then return end
	local result = symm.transfer(get_fruits, 1)
	print("The final index was " .. tostring(result))
end
		
symm.main = run_main
symm.current = symm.main

run_main()