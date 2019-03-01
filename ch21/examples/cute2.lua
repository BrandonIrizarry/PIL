
function Set (list)
	local set = {}

	for _, v in ipairs(list) do
		set[v] = true
	end
	
	return set
end

function fmt_write (msg, ...)
	return io.write(string.format(msg, ...))
end

nowhere = {}
nowhere.name = "nowhere"
count = 0

-- A prototype chain.
function nowhere:new (name, items)
	items = items or Set {} -- a default place has no items
	items.name = name
	
	self.__index = function (client, key)
		print(client.name, key)
		count = count + 1
		return self[key]
	end
	
	setmetatable(items, self)
	
	return items
end


-- 'new' is only defined for _nowhere_, so the subsequent calls to 'new'
-- by newer, "upstart" tables will trigger the print statement in the 
-- prior table (the metatable of the current one.)
-- It will always find 'new' in nowhere, but there's a "triangle number
-- effect" in the print statements that was very confusing.
bathroom = nowhere:new("the bathroom", Set {"toothbrush", "towel", "soap"})
kitchen = bathroom:new("the kitchen", Set {"cup", "paper towels", "napkins", "chair"})
--living_room = kitchen:new("the living room", Set {"remote", "index cards", "scissors", "stapler"})
--bedroom = living_room:new("the bedroom", Set {"book", "laptop", "tissues", "lip balm", "socks"})

--print("here: ", bathroom.rocks)
--return bathroom.rocks
--print(bedroom:find("racecar"))
--print(bedroom:find("napkins"))

