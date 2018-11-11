--[[
	Explain the following results:
	
	math.maxinteger * 2 --> -2
	math.mininteger * 2 --> 0
	math.maxinteger * math.maxinteger --> 1
	math.mininteger + math.mininteger --> 0
	
1. M == 2^63 - 1, so 2M == 2^64 - 2, which, mod 2^64 is -2.
2. m == 2^63, so 2m == 2^64, which mod 2^64, is 0.
3. M * M == 2^64(2^62) + 2^64 + 1, which, mod 2^64, is 1.
4. m + m == 2m, which we saw was 0.
]]