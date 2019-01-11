function reload ()
	package.loaded["/home/brandon/PIL/ch13/chapter_examples/floor.lua"] = nil
	dofile("/home/brandon/PIL/ch13/chapter_examples/floor.lua")
end



function test (N)
	for i = 1, N do
		local comp1 = math.floor(math.floor(N/2)/i) * 2
		local comp2 = math.floor(((N/2)/i)*2)
		local diff = math.abs(comp1 - comp2)
		assert(diff <= 1 and comp1 <= comp2)
		local msg = ""
		if diff > 0 then msg = "Diff is at most 1!" end
		print(comp1, comp2, msg)
	end
end

test(27)
