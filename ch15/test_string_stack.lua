

local StringStack = require("string_stack").StringStack

stack = StringStack("a")

stack.push(1)
stack.give(true)
stack.push(1)
stack.give(true)
r = stack.pop()
print(r)
stack.give(true)