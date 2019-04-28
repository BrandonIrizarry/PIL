local routines = {}

routines.doOnce = function (phrase)
	print(phrase)
end

routines.doOnce("Hello, World")

routines.doLoop = function (num_iterations)
	for i = 1, num_iterations do
		print("Iteration: ", i)
	end
end

routines.doLoop(3)

routines.doTextChar = function (phrase)
	local nchars = #phrase
	
	for i = 1, nchars do
		print(phrase:sub(i,i))
	end
end

routines.doTextChar("brown")