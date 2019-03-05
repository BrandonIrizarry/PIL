function whoami ()

	local c = {}
	
	function c.add (x, y)
		return x + y
	end
	
	return c
end

function Set (seq)
	local set = {}
	
	for i = 1, #seq do
		set[seq[i]] = true
	end
	
	return set
end

function search (key, plist)
	for i = 1, #plist do
		local value = plist[i][key]
		if value then return value end
	end
end

collection_A = Set {"toothbrush", "toothpaste", "sink", "shower"}
collection_B = Set {"TV", "guest bed", "remote", "pillow"}

plist = {collection_A, collection_B}

print(search("remote", plist))
print(search("talisman", plist))