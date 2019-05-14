local coro = require "coro"

function get_string ()
	local str = coro.transfer(numbers, "")

	print("Final string: " .. str)
end


function numbers (str)
	for _, num in ipairs({1,2,3}) do
		io.write("Is this good? " .. num .. "\n")
		local ans = io.read()
		print("ans is " .. ans)
		
		if ans == "n" then
			str = coro.transfer(letters, str)
		else
			str = str .. tostring(num)
			print("str is: " .. str)
		end
	end
end

function letters (str)
	for _, let in ipairs({'a', 'b', 'c'}) do
		print("Is this good? " .. let)
		local ans = io.read()
		
		if ans == "n" then
			str = coro.transfer(numbers, str)
		else
			str = str .. let
			print("str is: " .. str)
		end
	end
end

get_string = coro.create(get_string)
numbers = coro.create(numbers)
letters = coro.create(letters)
coro.main = get_string

coro.main()