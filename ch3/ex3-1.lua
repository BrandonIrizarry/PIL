function reload ()
  package.loaded["/home/brandon/Documents/Textbooks/PIL/ch3/ex3-1.lua"] = nil
  dofile("/home/brandon/Documents/Textbooks/PIL/ch3/ex3-1.lua")
end

--[[
	Which of the following are valid numerals?
What are their values?

.0e12 -- 0.0
.e12 -- invalid
0.0e -- invalid
0x12 -- 18 
0xABFG -- invalid
0xA -- 10
FFFF -- invalid
0xFFFFFFFF -- 2^32 -1, or 4294967295.0
0x -- invalid
0x1P10 -- 2^10, or 1024.0
0.1e1 -- 1.0
0x0.1p1 -- 0.125
]]
