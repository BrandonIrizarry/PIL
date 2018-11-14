--[[
	What is the result of the expression 2^3^4? What about                     
2^-3^4?
]]

assert(2^3^4 == 2^81)
assert(2^-3^4 == 2^-(3^4))