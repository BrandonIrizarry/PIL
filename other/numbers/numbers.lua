function fmt_write(fmt, ...)
	return io.write(string.format(fmt, ...))
end

local RECORD_ENTRY = ",?([^,]*)"
M = {}
revM = {}

local test_file = "testfile.csv"
local real_file = "numbers_win4_since_1980.csv"

csv_fstream = io.open(real_file)

function listify_record (rtext)
	local list = {}
	
	for entry in rtext:gmatch(RECORD_ENTRY) do
		if entry:match("^%s*$") then
			entry = false
		end
		
		list[#list + 1] = entry
	end
	
	return list
end

header = listify_record(csv_fstream:read()) -- read the first line, with all the headers, and listify it.

-- M is used to look up by index, and revM, by string-query.
for _, category in ipairs(header) do
	M[category] = {}
	revM[category] = {}
end

local index = 1
for line in csv_fstream:lines() do	
	local record = listify_record(line)
	
	for i, entry in ipairs(record) do
		local category = header[i]
	
		M[category][index] = entry
		
		local occurences = revM[category][entry] -- alias for a bit.
		
		if not occurences then occurences = {} end
		
		table.insert(occurences, index)
	
	
		--print(category, occurences)
		
		revM[category][entry] = occurences -- hook it back up.
	end
	
	index = index + 1
end


function print_M ()
	for category, listing in pairs(M) do
		fmt_write("%s %s %d\n", category, type(listing), #listing)
		
		for _, entry in ipairs(listing) do
			io.write(tostring(entry), " ")
		end
		
		io.write("\n")
	end
end

function print_revM ()
	for category, rev_listing in pairs(revM) do
		fmt_write("%s\n", category)
		
		for entry, index_list in pairs(rev_listing) do
			fmt_write("%s=", tostring(entry))
			
			for _, index in ipairs(index_list) do
				fmt_write(" %d", index)
			end
			
			io.write("\n")
		end
		
		io.write("\n")
	end
end

-- e.g on what dates did 444 come out in Midday?
function query_date (result_name, result)
	local indices = revM[result_name][result]
	
	fmt_write("%s: %s came out on the following date(s):\n", result_name, result)
	for _, index in ipairs(indices) do
		print(M["Draw Date"][index])
	end
end

query_date("Midday Daily #", "444")
--[[
Midday Daily #: 444 came out on the following date(s):
09/20/2017
11/27/2012
06/15/2006
02/11/2005
]]

-- e.g. what was the midday result on 01/01/2019?
function query_result (result_name, date_str)
	local index = revM["Draw Date"][date_str][1] -- The "Draw Date" field is the column of keys, so this suffices.
	
	fmt_write("The %s on %s was: %s\n", result_name, date_str, M[result_name][index])
end

query_result ("Midday Daily #", "01/01/2019") --> 473
