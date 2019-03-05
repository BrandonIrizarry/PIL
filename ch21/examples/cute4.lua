
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

-- Definitions.

collection_A = 		Set {"toothbrush", "towel", "soap"}
collection_B = 		Set {"remote", "index cards", "scissors", "stapler"}
collection_C = 		Set {"book", "laptop", "tissues", "lip balm", "socks"}
collection_D = 		Set {"cup", "paper towels", "napkins", "chair"}

bathroom = collection_A
bathroom.name = "the bathroom"

-- A prototype chain.

-- tbc 
-- right now, the only way I know how to do this is
-- to log each access in a separate, global table.
	
function bathroom:new (name, items)
	
	items.name = name
	
	self.__index = function (client, key)
	
		fmt_write("Item '%s' not found in %s\n", key, client.name)
		--fmt_write("%s%s\n", object_list[object_ptr], self.name)
		fmt_write("%s\n", self.name)
		
		return self[key]
	end
	
	setmetatable(items, self)
	
	return items
end



living_room = bathroom:new("the living room", collection_B)
bedroom = living_room:new("the bedroom", collection_C)