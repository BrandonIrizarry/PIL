
r = require "Stack" 

print(r.contents) -- is now nil!

r:push("a")
r:push("b")
r:push("c")

print(r, "top: ", r:top())
--[[ 
	Note that we couldn't define another stack operation here,
since we'd need to write our own module with its own protector
table for that.
]]

r:pop()
r:pop()
print(r)
r:pop()
print(r)
r.contents = {"D"}
assert(r:isempty())
print(r) -- still empty

