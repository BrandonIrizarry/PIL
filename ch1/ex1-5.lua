--[[
  What is the value of the expression 
  
  type(nil)==nil
  
  (You can use Lua to check your answer.)
  Can you explain this result?
  
  The answer should be 'false', since type(type(nil)) is "string", 
  and type(nil) is "nil", and these aren't equal; and two things
  of different types can't have equal values.
]] 