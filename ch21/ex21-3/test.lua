-- Note: 's' _is_ already a (derived) Stack!
-- Therefore, all methods are accessed via the metatable (the Stack prototype),
-- and can't be altered on 's'.

-- I should've probably included 'contents' in the prototype, which would've
-- allowed me to use the original Stack (it shouldn't be considered something
-- abstract.) I'll keep this in mind for later classes/prototypes.
s = require "Stack" 

print(s.contents) -- is now nil!

s:push("A")
s:push("B")
s:push("C")
print(s)
s:pop()
s:pop()
print(s)
s:pop()
print(s)
s.contents = {"D"}
print(s) -- still empty
