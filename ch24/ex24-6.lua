--[[
	Exercise 24.6
	
	Implement a transfer function in Lua. If you think about resume-yield as 
similar to call-return, a transfer would be like a goto: it suspends the 
running coroutine and resumes any other coroutine, given as an argument. 
	(Hint: use a kind of dispatch to control your coroutines. Then, a transfer
would yield to the dispatch signalling the next coroutine to run, and the
dispatch would resume the next coroutine.)
]]

dispatch = coroutine.wrap(function (co1, co2, co3)
	local curr = co1

	while true do
		curr = coroutine.resume(curr)
	end
end)

function transfer(next_co)
	-- tbc.

end

F = {"apples", "oranges", "pineapples",  "grapes", "passionfruit"}
V = {"broccoli", "cilantro", "tomatoes", "carrots", "bell peppers"}

fruits = nil

vegetables = coroutine.create(function ()
	for _, v in ipairs(V) do
		if v == "tomatoes" then
			transfer(fruits)
		end
		
		coroutine.yield(v)
	end

fruits = coroutine.create(function ()
	for _, f in ipairs(F) do
		if f == "pineapples" then
			transfer(vegetables)
		end
		
		coroutine.yield(f)
	end
end






	