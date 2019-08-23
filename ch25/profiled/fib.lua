local fib

fib = function (n)
	if n == 0 then return 0 end
	if n == 1 then return 1 end
	
	return fib(n - 1) + fib(n - 2)
end

return fib