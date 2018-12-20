--[[
	Exercise 8.5

	Can you explain why Lua has the restriction that a goto cannot jump
out of a function? (Hint: how would you implement that feature?)
]]

print [[
	See this SO answer:

	https://stackoverflow.com/questions/18646289/why-cant-gotos-in-lua-jump-out-of-functions

	Excerpt:

	"The reason is because the goto statement and its destination
	must reside in the same stack frame. The program context before
	and after the goto need to be the same otherwise the code being
	jumped to won't be running in its correct stack frame and its
	behavior will be undefined. goto in C has the same restrictions
	for the same reasons."
]]
