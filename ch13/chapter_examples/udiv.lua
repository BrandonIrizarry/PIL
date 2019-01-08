function reload ()
	package.loaded["/home/brandon/PIL/ch13/chapter_examples/udiv.lua"] = nil
	dofile("/home/brandon/PIL/ch13/chapter_examples/udiv.lua")
end


function udiv (n, d)
	if d < 0 then
		if math.ult(n, d) then
			return 0, n
		else
			return 1, n - d
		end
	end

	local q = ((n >> 1) // d) << 1
	local r = n - q * d

	if not math.ult(r, d) then
		q = q + 1
		r = r - d
	end

	return q, r
end

function phex (val)
	return string.format("%x", val)
end

for i = 1, 20 do
	local q, r = udiv(20, i)
	print(string.format("%d/%d:", 20, i), q, string.format("%d+%d=20", q*i, r))
end
