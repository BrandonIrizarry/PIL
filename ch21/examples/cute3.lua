
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

CLIENT = ""

-- A prototype chain.
function nowhere:new (name, items)
	items = items or Set {} -- a default place has no items
	items.name = name
	
	self.__index = function (client, key)
		print(client.name, key)
		return self[key]
	end
	
	setmetatable(items, self)
	
	return items
end

track = require("proxy-all").track

bathroom = nowhere:new("the bathroom", Set {"toothbrush", "towel", "soap"})
bathroom = track(bathroom)
kitchen = bathroom:new("the kitchen", Set {"cup", "paper towels", "napkins", "chair"})
--living_room = kitchen:new("the living room", Set {"remote", "index cards", "scissors", "stapler"})
--bedroom = living_room:new("the bedroom", Set {"book", "laptop", "tissues", "lip balm", "socks"})
