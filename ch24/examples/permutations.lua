function printResult (a)
	for i = 1, #a do
		io.write(a[i], " ")
	end
	
	io.write("\n")
end


function permgen (a, n)
	n = n or #a
	
	if n <= 1 then -- base case
		coroutine.yield(a)
	else
		for i = 1, n do
			
			-- swap a_n with a_i
			a[n], a[i] = a[i], a[n]
			
			-- generate all permutations of the other elements
			permgen(a, n - 1)
			
			-- restore a_n and a_i
			a[n], a[i] = a[i], a[n]
		end
	end
end

function permutations (a)
	local co = coroutine.create(function () permgen(a) end)
	
	return function () -- iterator
		local good, result = coroutine.resume(co)
		return result
	end
end

-- Use 'coroutine.wrap'.
function permutations_v2 (a)
	return coroutine.wrap(function () permgen(a) end)
end

for perm in permutations_v2 {'a', 'b', 'c'} do
	printResult(perm)
end