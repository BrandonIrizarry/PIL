--[[
	Exercise 13.1

	Write a function to compute the modulo operation for unsigned integers.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch13/ex13-1.lua"] = nil
	dofile("/home/brandon/PIL/ch13/ex13-1.lua")
end


-- Based on Listing 13.1 (udiv)
function umod (n, d)
	local rem, quot -- quot is used for tests.

	if d < 0 then -- d >= 2^63.
		if math.ult(n, d) then
			rem, quot = n, 0
			goto finish
		else
			rem, quot = n - d, 1
			goto finish
		end
	end

	-- Calculate the remainder using the quotient.
	quot = ((n >> 1) // d) << 1
	rem = n - quot * d

	if not math.ult(rem ,d) then
		rem, quot = rem - d, quot + 1
		goto finish
	end

	::finish::
	return rem, quot
end


function test1 ()
	local x63 = 1 << 63
	local X = -1

	print(umod(X, x63))
	assert(umod(X, x63) == -1 >> 1)
	print(umod(x63, x63))
	assert(umod(x63, x63) == 0)
end

function test2 (N)
	for i = -N, N do
		if i ~= 0 then -- if i == 0, then the quot calculation in umod will fail.
			local r, q = umod(N, i)
			assert(q*i + r == N)
			io.write(string.format("%d mod %d: %d; %d+%d=%d\n", N, i, r, q*i, r, N))
		end
	end
end

test1()
test2(20)
