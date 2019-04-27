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