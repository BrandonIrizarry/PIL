--[[
  Run the 'twice' example, both by loading the file with the -l option
and with 'dofile'. Which way do you prefer?
]]

function reload ()
  package.loaded["/home/brandon/Documents/Textbooks/PIL/ch1/ex1-2.lua"] = nil
  dofile("/home/brandon/Documents/Textbooks/PIL/ch1/ex1-2.lua")
end

function norm (x, y)
  return math.sqrt(x^2 + y^2)
end

function twice (x)
  return 2.0 * x
end

-- I'm more comfortable with "dofile".