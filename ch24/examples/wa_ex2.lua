-- Make global for debugging purposes.
routines = {}

function routines.doOnce (phrase)
	print(phrase)
end

function routines.doLoop (num_iterations)
	for i = 1, num_iterations do
		print("Iteration: ", i)
		coroutine.yield()
	end
end

function routines.doTextChar (phrase)
	local nchars = #phrase
	
	for i = 1, nchars do
		print(phrase:sub(i,i))
		coroutine.yield() -- note that these, for now, are 'empty yields'
	end
end

--[[
doOnceT = coroutine.create(routines.doOnce)
doLoopT = coroutine.create(routines.doLoop)
doTextCharT = coroutine.create(routines.doTextChar)
--]]

return routines