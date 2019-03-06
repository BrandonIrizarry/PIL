Stack = require "Stack"

-- Test.
s = Stack:new ()
s:push("faucets")
print(s:top())
s:push("open")
print(s:top())
s:push("till-full")
print(s:top())
print(s:isempty())
s:pop()
s:pop()
print(s:top())
s:pop()
print(s:isempty())

-- No privacy.
s.contents = {"hi", "there"}
print(s:isempty())

print("Example of printing a stack: ", s)