expr = "Lx.x"
inside = expr

if expr:match("%(.+)") then
	print("application")
else
	print("something else")
end

--[[
function parse (expr)
	local first_char = expr:sub(1,1)
	
	if first_char == "L" then
		local param, dot, body = expr:sub(2,2), expr:sub(3,3), expr:sub(4)
		
		if dot ~= "." then error "Not a valid FUNCTION" end
		
		return {type = "FUNCTION", param = param, body = parse(body)}
	
	elseif first_char == "(" then
		local lhs, rhs = expr:match("%((.+) (.+)%)")
		return {type = "APPLICATION", lhs = parse(lhs), rhs = parse(rhs)}
	
	else
		return {type = "NAME", contents = expr}
	end
end
--]]



