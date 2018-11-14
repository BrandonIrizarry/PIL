function reload ()
  package.loaded["/home/brandon/PIL/ch3/ex3-3.lua"] = nil
  dofile("/home/brandon/PIL/ch3/ex3-3.lua")
end

--[[
	What will the following program print out?
]]

for i = -10, 10 do
	print(i, i % 3)
end

--[[
	For each value of i, it'll print i,
side-by-side with the i + M, where M is the
smallest multiple of 3 that would make i + M non-negative.

Hence, the printout starts:
-10 2
-9 0
-8 1
-7 2
-6 0
...
]]