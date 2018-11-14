--[[
	The number 12.7 is equal to the fraction 127/10, where the 
denominator is a power of ten. Can you express it as a common fraction
where the denominator is a power of two? What about the number 5.5?

	The number 12.7, in binary, is 1100.10{1100}, where the bracketed part
repeats infinitely. Because its binary expansion is infinite, 12.7 can't
be expressed as a common fraction where the denominator is a
power of two.
	Assume 12.7 can be written as the reduced fraction A/2^k. 
Performing the division yields Q + R/2^k, where Q is an integer,
R/2^k is already reduced, and R < 2^k. One way to proceed is to note
that 2^k(Q + R), when expressed in binary, has a finite number of digits.
Hence, 12.7 can't manufacture such a number, nor does the binary expansion
converge to a finite number.
	The number 5.5, however, is easy: 11/2.
]]


