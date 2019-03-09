--[[
	Listing 21.2
	
	An implementation of multiple inheritance.
]]

-- look up for 'k' in list of tables 'plist'
local function search (field, class_directory)
	for _, superclass in ipairs(class_directory) do
		local value = superclass[field] 
		if value then return value end
	end
end


function createClass (...)
	local class = {}
	local parents = {...}
	
	-- the class searches for absent methods in its list of parents
	local redirect = {__index = 
		function (child, key)
			return search(key, parents)
		end
	}
	
	setmetatable(class, redirect)
	
	-- prepare 'c' to be the metatable of its instances
	class.__index = class -- like 'self.__index = self'

	-- define a new constructor for this new class
	function class:new (data)
		data = data or {}
		setmetatable(data, class)
		return data
	end
	
	return class 
end


-- Now, some classes.
Named = {}

function Named:getname ()
	return self.name
end

function Named:setname (name)
	self.name = name
end

Account = {balance = 0}

function Account:new ()
	local acct = {balance = 0}
	
	self.__index = self
	setmetatable(acct, self)
	
	return acct
end

