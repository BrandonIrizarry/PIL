--[[
	Exercise 18.2
	
	Add a step parameter to the iterator from the previous exercise.
Can you still implement it as a stateless iterator?
]]

function fromto (n, m, step)
	step = step or 1
		
	local i = n - step
	
	return function ()
		i = i + step
	
		if step < 0 then
			if i < m then
				return nil
			else
				return i
			end
		elseif step > 0 then
			if i > m then
				return nil
			else 
				return i
			end
		else
			error("zero step is not allowed.")
		end
	end
end
	
function p_inc (n, m, step)
	
	for i in fromto(n, m, step) do
		print(i)
	end
	
	print()
end


p_inc(5, 10, 2)
p_inc(10, 5, -2)
p_inc(-1, -5, -1)
p_inc(-5, -1, 1)