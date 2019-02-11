--[[
	Exercise 16.4

	Can you find any value for f such that the call pcall(pcall, f)
returns 'false' as its first result? Why is this relevant?  
]]

--[[
https://stackoverflow.com/questions/39113323/how-do-i-find-an-f-that-makes-pcallpcall-f-return-false-in-lua

https://github.com/xfbs/PiL3/blob/master/08Compilation/pcall.lua 
]]

function f ()
  count = 0
  
  -- the hook function
  function g ()
    count = count + 1
    -- unset the hook function, otherwise when the outer pcall
    -- returns, there will be an error, and print wont't receive
    -- the result.
    -- raise an error
    if count == 2 then debug.sethook() end
    error("an error in 'g'")
  end
  -- run when a function returns
  debug.sethook(g, "r")
end

-- Both f() and pcall(f) will throw an error; but I don't quite
-- understand what's going on.
