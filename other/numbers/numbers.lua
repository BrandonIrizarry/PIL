function fmt_write(fmt, ...)
	return io.write(string.format(fmt, ...))
end

local RECORD_ENTRY = ",?([^,]*)"
local M = {}
local revM = {}

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
		revM[category][entry] = index
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
		
		for entry, i in pairs(rev_listing) do
			fmt_write("%s=%d ", tostring(entry), i)
		end
		
		io.write("\n")
	end
end

function query_date (date_str)
	local index = revM["Draw Date"][date_str]
	print(index)
	
	for category, listing in pairs(M) do
		fmt_write("%s=%s\n", category, listing[index])
	end
end

function query_result (category, your_result)
	local index = revM[category][your_result]
	
	print(M["Draw Date"][index])
end

query_date("01/19/2019")
query_result("Midday Daily #", "119") -- for the real file, it looks like overwriting takes place.
query_result("Midday Daily #", "213") -- we need to make sure we're getting the most recent one first,
-- or else keep a list of all dates where this particular number came out. tbc.