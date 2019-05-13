

Set = require "set"

s = Set:new{"house", "car"}
s:add"flowers"
s:add"corn"
s:add"grapes"

-- 's' should report a size of 5.
print(s:size() == 5)

w = s:new()

-- 'w' should have the same size as s.
print(w:size() == 5)

s:remove"flowers"

-- Both w and s should be down by one.
print(s:size() == 4)
print(w:size() == 4)

w:add"candy"

-- w can add things independently of s.
print(w:size() == 5)
print(s:size() == 4)

-- Remove something found in s, but not original to w.
w:remove"corn"
print(w:size() == 5) 
print(w.corn)
w:display_removable()
q = w:new()

q:display_removable()
print(q:size())
print(q.corn)
q:remove"grapes"
print(q:size())


