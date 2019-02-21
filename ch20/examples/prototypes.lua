-- create the prototype. This, by definition, is a table of default values.

prototype = {x = 0, y = 0, width = 100, height = 100}

local mt_p = {} -- the metatable that will access the prototype.

-- The constructor function's only purpose is to associate a given table
-- with the metatable.

function new (o)
	setmetatable(o, mt_p)
	return o
end

-- __index is a metamethod, that is, a function: client, key --> what to return.
mt_p.__index = function (_, key) return prototype[key] end
-- OR: mt_p.__index = prototype -- will work the same.

-- Example:
w = new {x = 10, y = 20}
print("For the window example: ", w.width) -- trigger w's metatable's __index metamethod.

-- Another example.

address_template = {country = "USA", area_code = "212"}

-- I want to create a series of address objects. But I need a metatable,
-- and the constructor should associate these objects with that metatable.

local mt_addr = {}

function new_address (a)
	setmetatable(a, mt_addr)
	return a
end

mt_addr.__index = address_template

-- Now, we can make addresses:
brandon = new_address {building = "310", street = "West 14th Street"}

print()
print("The address template example: ")
print(brandon.building)
print(brandon.street)
print(assert(brandon.country)) -- relying on the prototype.
print(assert(brandon.area_code)) -- relying on the prototype.
-- 'assert' is to make sure the fields aren't, in fact, nil.

-- Let's try a third example.
-- Keep both the prototype and the metatable as local variables within
-- the constructor itself.

function new_employee (e)
	local defaults = {shirt="blue", hours="37.5", vacation="yes"}
	local mt = {}
	mt.__index = defaults
	setmetatable(e, mt)
	
	return e
end

local cenicienta = new_employee {store = "chelsea", favorite="berry powerful"}

print()
print("An example involving employees.")
print(assert(cenicienta.shirt)) -- got it!
