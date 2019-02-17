--[[
	Exercise 17.3
	
	What happens in the search for a library if the path has some fixed
component (that is, a component without a question mark)? Can this behavior
be useful?
]]

--[[
	If that fixed component were concatenated to the end of package.path,
it would serve as a default module to load in case 'require' doesn't find
the module it's looking for.
]]