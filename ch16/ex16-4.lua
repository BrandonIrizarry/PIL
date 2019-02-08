--[[
	Exercise 16.4
	
	Can you find any value for f such that the call pcall(pcall, f) returns 'false' as its
first result? Why is this relevant?
]]

--[[
	The function pcall never raises any error, no matter what, so pcall(pcall, f) can never
return 'false' as its first result, no matter what - given that f is a valid Lua expression.

See this link:

https://stackoverflow.com/questions/39113323/how-do-i-find-an-f-that-makes-pcallpcall-f-return-false-in-lua

https://github.com/xfbs/PiL3/blob/master/08Compilation/pcall.lua
]]

-- tbc, how does this work/is it kosher?
-- whatever, it _is_ a value of 'f' that causes 'pcall' to return false!
-- So, why is this relevant?!

function f ()
  count = 0
  
  -- the hook function
  local function g ()
    count = count + 1
    -- unset the hook function, otherwise when the outer pcall
    -- returns, there will be an error, and print wont't receive
    -- the result.
    -- raise an error
	if count == 2 then debug.sethook() end
    error()
  end
  
  -- run when a function returns
  debug.sethook(g, "r")
end

print(pcall(pcall, f))
