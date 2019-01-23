

local patterns = {
	
	RECORD_KEY = "^(.-),",
	RECORD_VALUE = ",([^,]*)",
	RECORD_ENTRY = ",?([^,]*)"
}

local examples = {
	"08/05/2018,232,7,214,7,3156,15,3085,16,  ,  ,05,05",
	"01/05/2019,917,,891,,6285,,6772,,  ,  ,  ,"
}

local example = examples[1]

local header = "Draw Date,Midday Daily #,Midday Daily Sum,Evening Daily #,Evening Daily Sum,Midday Win 4 #,Midday Win 4 Sum,Evening Win 4 #,Evening Win 4 Sum,Midday Daily Booster,Evening Daily Booster,Midday Win 4 Booster,Evening Win 4 Booster"

for _, ex in ipairs(examples) do
	local count = 0
	
	for entry in ex:gmatch(patterns.RECORD_ENTRY) do
		count = count + 1
	end
	
	print(count)
end

-- Converts the text of a CSV record into a Lua sequence;
-- listified record, or lrecord.
function listify_record (record)
	local entries = {}
	
	for e in record:gmatch(patterns.RECORD_ENTRY) do
		entries[#entries + 1] = e
	end
	
	return entries
end

-- Convert an lrecord into a dict which can be easily inserted into a parent category.
--[[
function zip_with_header (lr)
	local dict = {}
	local H = listify_record(header)
	
	dict[1] = lr[1]
	
	for i = 2, #H do
		local h = H[i] -- the current header (what the ipairs "value" would've been)
		dict[h] = lr[i]
	end
	
	return dict
end
--]]

-- We want this version of the zipper function.  
-- However, we'll also need a way to iterate through a
-- dict in an order defined by another sequence (listify_record(header)!),
-- I need an iterator for zrecords. tbc, next time. 

function zip_with_header (lr)
	local dict = {}
	local H = listify_record(header)
	
	for i, h in ipairs(H) do
		dict[h] = lr[i]
	end
	
	return dict
end
--[[
function add_to_parent(zr, P)
	local H = listify_record(header)

	
end
--]]

local L1 = listify_record(examples[1])
local L2 = listify_record(examples[2])

function print_lrecord (lr)
	for i, h in ipairs(lr) do
		print(i, h)
	end
end

function print_zrecord (zr)	
	for key, value in pairs(zr) do
		print(key, value)
	end
end

Z1 = zip_with_header(L1)
print_zrecord(Z1)

