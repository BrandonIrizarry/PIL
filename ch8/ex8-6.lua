--[[

	Exercise 8.6

	Assuming that a goto could jump out of a function, explain what the
program in Listing 8.3 would do. (Try to reason about the label using the
same scoping rules used for local variables.
]]

--[[
	Let's try a simplified version of the code, that indeed falls through:
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch8/ex8-6.lua"] = nil
  dofile("/home/brandon/PIL/ch8/ex8-6.lua")
end

function f(n)
	if n == 0 then return 0
	else
		local res = f(n - 1)
		print(n)
		return res
	end
end

x = f(10)
assert(x == 0)

--[[
	Note how the innermost calls print their inputs first, so the
numbers print in ascending order. Listing 8.3 would do the same.
	If we use function calls to emulate labels, we can then  the closest working
program that fulfills the exact intent of the original would be:
]]


function finish()
	return 0
end

function getlabel()
	return function()
		return finish()
	end
end

-- Redefine f.
function f(n)
	if n == 0 then return getlabel()
	else
		local res = f(n - 1)
		print(n)
		return res
	end
end

x = f(10)
assert(x() == 0) -- the intended value of x() in the Listing, given the positioning of the label L1.

