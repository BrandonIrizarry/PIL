local lpeg = require("lpeg")
local white = lpeg.S(" \t\r\n") ^ 0

local integer = white * lpeg.R("09") ^ 1 / tonumber
local muldiv = white * lpeg.C(lpeg.S("/*"))
local addsub = white * lpeg.C(lpeg.S("+-"))

local function node(p)
  return p / function(left, op, right)
    return { op, left, right }
  end
end

local calculator = lpeg.P({
  "input",
  input = lpeg.V("exp") * -1,
  exp = lpeg.V("term") + lpeg.V("factor") + integer,
  term = node((lpeg.V("factor") + integer) * addsub * lpeg.V("exp")),
  factor = node(integer * muldiv * (lpeg.V("factor") + integer))
})

function print_node (t)
	local op, left, right = t[1], t[2], t[3]
	if type(left) == "table" then
		print_node(left)
	else
		io.write(left, " ")
	end
	
	io.write(op, " ")
	
	if type(right) == "table" then
		print_node(right)
	else
		io.write(right, " ")
	end
end

--print_node(calculator:match("5*3+4*6"))
print_node(calculator:match("4-3*12/6+1"))
inspect = require("inspect").inspect

print(inspect(calculator:match("4-3*12/6+1")))