
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


local bathroom = 	Set {"toothbrush", "towel", "soap"}
local living_room = Set {"remote", "index cards", "scissors", "stapler"}
local bedroom = 	Set {"book", "laptop", "tissues", "lip balm", "socks"}
local kitchen = 	Set {"cup", "paper towels", "napkins", "chair"}

bathroom.name = "the bathroom"
living_room.name = "the living room"
bedroom.name = "the bedroom"
kitchen.name = "the kitchen"

function link(room_a, room_b)
	local mt = 
		{
			__index =  function (p, key)
				fmt_write("'%s' not found in %s; searching somewhere else...\n", key, p.name)
				return room_b[key]
			end
		}
	setmetatable(room_a, mt)
end

link(bedroom, living_room)
link(living_room, kitchen)
link(kitchen, bathroom)

setmetatable(bathroom, {__index = 
						function (_, key) 
							fmt_write("'%s' is nowhere to be found.\n", key) 
						end})

function find (item)
	local result = bedroom[item]
end

--print(find("soap"))
print(bedroom.keys)