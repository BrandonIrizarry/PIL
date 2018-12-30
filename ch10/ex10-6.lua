--[[
	Exercise 10.6

	Rewrite the function 'transliterate' for UTF-8 characters.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch10/ex10-6.lua"] = nil
	dofile("/home/brandon/PIL/ch10/ex10-6.lua")
end


function transliterate (utf8_str, map)
	return (utf8_str:gsub(utf8.charpattern, function (c)
		local new_char = map[c]

		if new_char == false then
			return ""
		else
			return new_char
		end
	end))
end

function main ()
	local azeri = "Zəfər, jaketini də papağını da götür, bu axşam hava çox soyuq olacaq."
	local greek = "Ξεσκεπάζω τὴν ψυχοφθόρα βδελυγμία."
	local russian = "Съешь же ещё этих мягких французских булок, да выпей чаю."

	local map = {
		["м"] = "m",
		["р"] = "ə",
		["и"] = false,
	}

	return transliterate(russian, map)
end
