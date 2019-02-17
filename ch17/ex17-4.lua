--[[
	Exercise 17.4
	
	Write a searcher that searches for Lua files and C libraries at the same
time. For instance, the path used for this searcher could be something like
this:

./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua

(Hint: use 'package.searchpath' to find a proper file and then try to load it,
first with loadfile and next with 'package.loadlib'.
]]

--[[
	The following source was helpful for determining what 'funcname' to
use as the second argument to 'package.loadlib':

http://lua-users.org/wiki/LoadLibrary
]]

function double_searcher(name, path)
	local obj, msg = package.searchpath(name, path)
	
	if not obj then 
		return obj, msg 
	else
		-- 'obj' exists, and is the full path to the Lua file or C library.
		local c_name = string.format("luaopen_%s", name)
		return (loadfile(obj) or package.loadlib(obj, c_name))
	end
end

-- Some tests.
-- We assume 'lpeg' and 'lfs' are installed, e.g. via luarocks.

-- NB: Be careful not to add "ex17-4" (this file) as an example; you'll
-- trigger an infinite loop when you load its chunk!
local examples = {"lpeg", "lfs", "ex17-2.plot", "ex17-1"}

for _, ex in ipairs(examples) do

	-- Load and run each chunk.
	print(double_searcher(ex, package.path .. ";" .. package.cpath)())
end
