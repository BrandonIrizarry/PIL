StackQueue = require "StackQueue"

sq = StackQueue:new()

sq:push("A")
print(sq)
sq:push("B")
sq:push("C")
print(sq)
sq:insertbottom("[-c]")
sq:insertbottom("[-b]")
sq:insertbottom("[-a]")
print(sq)
sq:pop()
sq:pop()
sq:pop()
print(sq)
sq:pop()
sq:pop()
print(sq)
sq:insertbottom("D")
print(sq)
-- ... and so on.
