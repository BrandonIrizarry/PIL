--[[
	Exercise 10.7

	Write a function to reverse a UTF-8 string.
]]


function reload ()
	package.loaded["/home/brandon/PIL/ch10/ex10-7.lua"] = nil
	dofile("/home/brandon/PIL/ch10/ex10-7.lua")
end


-- One way to do it, using a 'utf8.sub' function
function utf8.sub (str, i, j)
	local j = j or -1
	local start = utf8.offset(str, i)
	local finish = utf8.offset(str, j)
	local points = {utf8.codepoint(str, start, finish)}

	return utf8.char(table.unpack(points))
end

function utf8.at (str, index)
	return utf8.sub (str, index, index)
end

-- Used for testing 'utf8.at'
function test1 ()
	for i = 1, 5 do
		print(utf8.at("Zəfər", i))
	end
end

-- Reverse a UTF-8 string.
function utf8.reverse (str)
	local chars = {} -- hold the reversed chars

	for i = utf8.len(str), 1, -1 do
		chars[#chars + 1] = utf8.at(str, i)
	end

	return table.concat(chars)
end

tibetan =
[[
	༈ དཀར་མཛེས་ཨ་ཡིག་ལས་འཁྲུངས་ཡེ་ཤེས་གཏེར། །ཕས་རྒོལ་ཝ་སྐྱེས་ཟིལ་གནོན་གདོང་ལྔ་བཞིན། །ཆགས་ཐོགས་ཀུན་བྲལ་མཚུངས་མེད་འཇམ་བྱངས་མཐུས། །མ་ཧཱ་མཁས་པའི་གཙོ་བོ་ཉིད་གྱུར་ཅིག།
]]

german = "Heizölrückstoßabdämpfung"

function main ()
	print("As is:")
	print(tibetan)
	print()
	print("Reversed:")
	print(utf8.reverse(tibetan))
	print("\n")
	print("As is:")
	print(german)
	print()
	print("Reversed:")
	print(utf8.reverse(german))
end

main()
