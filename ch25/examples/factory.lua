
local number = 15

-- The original "lucky number" function (here for narrative purposes)
local function lucky()
	print("your lucky number:", number)
end

function make_lucky(_ENV)
	return function ()	
		print("Your lucky number:", number)
	end
end

funny_env = {print = function () print"No lucky number for you" end}
l1 = make_lucky(funny_env)
l2 = make_lucky(_ENV)

l1()
l2()