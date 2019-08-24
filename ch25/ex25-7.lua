--[[
	Exercise 25.7
	
	Write a library for breakpoints. It should offer at least two functions:
	
	setbreakpoint(function, line) --> returns handle
	removebreakpoint(handle)
	
	We specify a breakpoint by a function and a line inside that function.
When the program hits a breakpoint, the library should call debug.debug.
	(Hint: For a basic implementation, use a line hook that checks whether
it is in a breakpoint; to improve performance, use a call hook to trace program
execution and only turn on the line hook when the program is running the target
function.)
]]

