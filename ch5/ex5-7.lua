--[[
	Exercise 5.7

	Write a function that inserts all elements of a given list into a given
position of another list.
]]

function insert (src, dest, index)

	if index > #dest or index < 1 then
		error("Index for insertion out of bounds.")
	end

	-- Prepare DEST for copying SRC
	table.move(dest, index, #dest, index + #src)

	-- Copy SRC into DEST
	table.move(src, 1, #src, index, dest)
end

local function print_table (t)
	for _, v in ipairs(t) do io.write(v, " ") end
	io.write("\n")
end


local function eq_list (list1, list2)
	if #list1 ~= #list2 then return false end

	for i = 1, #list1 do
		if list1[i] ~= list2[i] then return false end
	end

	return true
end

local function run_tests ()
	local examples = {
		{ {"a", "b"}, {1,2,3,4,5,6}, 3, {1,2,"a","b",3,4,5,6} },
	}

	for _, ex in ipairs(examples) do
		local src, dest, index, result = table.unpack(ex)
		insert(src, dest, index)
		assert(eq_list(dest, result))
	end
end

run_tests()
