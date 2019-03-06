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
-- ... and so on. But still no privacy:
sq.contents = {}
print(sq)

-- Trying to hijack the code like this doesn't work, since sq.push is nil anyway -
-- the 'push' method comes from Stack!
sq.push = nil 
sq:push("W")
print(sq, sq.push)
