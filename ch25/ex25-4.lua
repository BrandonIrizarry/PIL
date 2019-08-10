--[[
	Exercise 25.4
	
	Write an improved version of debug.debug that runs the given commands as
if they were in the lexical scope of the calling function. (Hint: run the commands
in an empty environment and use the __index metamethod attached to the function
'getvarvalue' to do accesses to variables.

e.g. {__index = getvarvalue}