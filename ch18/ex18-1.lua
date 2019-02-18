--[[
	Exercise 18.1
	
	Write an iterator 'fromto' such that the next loop becomes
equivalent to a numeric 'for':

	for i in fromto(n, m) do
		<body>
	end

Can you implement it as a stateless iterator?
]]

function fromto (n, m)

	local i = n - 1
	
	return function ()
		i = i + 1
		
		if i == m + 1 then
			return nil
		else
			return i
		end
	end
end

function p_inc (n, m)
	if n > m then error("Can't iterate backwards.") end
	
	for i in fromto(n, m) do
		print(i)
	end
	
	print()
end

p_inc(5, 10)
p_inc(0, 3)
p_inc(4, 4)
print(pcall(p_inc, 2, 1))