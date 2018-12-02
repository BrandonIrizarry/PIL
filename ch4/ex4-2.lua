--[[
  Exercise 4.2
  
  Suppose you need to write a long sequence of arbitrary bytes as a literal
string in Lua. What format would you use? Consider issues like readability,
maximum line length, and size.

  I would use the long-string-literal format (the one that uses double brackets.)
I can add newlines and tabs as I wish to format the code, so there are no
run-on lines, and the result is, overall, readable. However, if the snippet
weren't that big, it may be more sensible and readable to use the 
short-string-literal format (the one that uses quotation marks.)
]]