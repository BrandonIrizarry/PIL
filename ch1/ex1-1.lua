--[[
  Run the factorial example. What happens to your program
if you enter a negative number? Modify the example to avoid
this problem.
]]

function reload ()
  package.loaded["/home/brandon/Documents/Textbooks/PIL/ch1/ex1-1.lua"] = nil
  dofile("/home/brandon/Documents/Textbooks/PIL/ch1/ex1-1.lua")
end

-- Original example
function fact (n)
  if n == 0 then
    return 1
  else
    return n * fact (n - 1)
  end
end

-- The value -1 will skip the first condition, 
-- but trigger the second one, and will never reach the
-- base case.
-- Assume negative numbers should just return 1, like 0.
function good_fact (n)
  if n <= 0 then
    return 1
  else
    return n * good_fact (n - 1)
  end
end