--[[
  Exercise 4.3
  
  Write a function to insert a string into a given position
of another one:

> insert("hello world", 1, "start: ") --> start: hello world
> insert("hello world", 7, "small ") --> hello small world
]]

function insert(subj, pos, snippet)
  local left_side = string.sub(subj, 1, pos - 1)
  return left_side .. snippet .. string.sub(subj, pos)
end

local example1 = insert("hello world", 1, "start: ")
local example2 = insert("hello world", 7, "small ")

-- Demonstrate possible correctness :)
assert(example1 == "start: hello world")
assert(example2 == "hello small world")

-- Demo for the viewers :)
print(example1)
print(example2)