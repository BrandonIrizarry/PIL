

local StringStack = require("string_stack").StringStack

stack = StringStack("a")

stack.push(1)
print(stack.get_copy())
stack.push(1)
print(stack.get_copy())
r = stack.pop()
print(r)
print(stack.get_copy())
stack.push(2)
print(stack.get_copy())
r = stack.pop()
print(r)
print(stack.get_copy())
