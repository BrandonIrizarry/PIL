--[[
	Exercise 22.2
	
	Explain in detail what happens in the following program and what it 
will print:

local foo

do
	local _ENV = _ENV
	function foo () print(X) end
end

X = 13
_ENV = nil
foo()
X = 0
--]]

--Rewriting certain things makes the whole thing clear:

local foo

do
	local e = _ENV
	
	function foo ()
	
		-- If e were _ENV, we wouldn't need a prefix, since Lua uses
		-- the local _ENV upvalue by default to own global references.
		e.print(e.X) 
	end
end

_ENV.X = 13

-- Doctor the new environment to show error information
-- In other words, we don't just want 'X = 0' to throw an error and
-- stop the program; let's see what happens using print and pcall.
local new_gt = {print = print, pcall = pcall, error = error}
local closedefs = 
	{__newindex = 
		function () 
			error("Definitions are now closed for the current _ENV", 2) 
		end
	}
	
-- Make sure _ENV.X = 0 is no longer a legal assignment, even though
-- _ENV won't be nil in this example.
setmetatable(new_gt, closedefs)
		
-- Now change _ENV.
_ENV = new_gt

-- 
foo()

-- Encapsulate the offending line in some error-handling code.
print(pcall(function () _ENV.X = 0 end))

--[[
	Summary
	
	You need to understand two basic concepts to get how the above example
works:
	
	1. Let's say you're playing around with some basic, mere-mortal tables
at the Lua REPL:

	> t = {1,2,3}
	> a = t
	
	t and a are now references to the same table; if I change fields in one,
the fields of the other automatically change. However, if I change the value
of one of the tables:

	> t = {'a', 'b', 'c'}
	> a[1], a[2], a[3]
	1	2	3
	
As you can see, a still points to what t had pointed to; a and t have
independent lives and existences.

	2. In the original example, the function foo closes over the local _ENV.
Now there are two values of _ENV: the global one, and the one that the closure 
foo "carries around", which points to what global _ENV points to.
	The line _ENV.X = 13 trivially alters global _ENV, but also alters foo _ENV, 
since they point to the same table. However, changing global _ENV to a different 
value doesn't alter foo _ENV's referent (see (1)!)
	In my example, I used 'e' to refer to foo _ENV, since it's clear that 
e has nothing to do with how you change _ENV at a later point in the file.
	Finally, if _ENV is nil, then clearly _ENV.X = 0 will throw an error, since
you can't index nil.
--]]
	
	