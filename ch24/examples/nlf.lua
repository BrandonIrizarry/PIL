

local numbers, letters, figures = {}, {}, {}

-- Short versions of the above. Make sure these are sets, not sequences!
local s_num = {[1] = true, [2] = true, [3] = true}
local s_lett = {["a"]=true, ["b"]=true, ["c"]=true}
local s_fig = {["!"]=true, ["@"]=true, ["#"]=true}

-- Contains numbers.
for i = 1, 10 do
	numbers[i] = true
end

-- Contains lower-case letters.
for i = 0, 25 do
	letters[string.char(97 + i)] = true
end

-- Contains some non-alphanumeric figures.
for i = 0, 15 do
	figures[string.char(33 + i)] = true
end

-- Display the contents of one of these sets.
function print_set (set)
	for s in pairs(set) do
		io.write(tostring(s), " ")
	end
	
	io.write("\n")
end

function fmt_write (fmt, ...)
	io.write(string.format(fmt, ...))
end

return {	
			numbers = numbers, 
			letters = letters,
			figures = figures, 
			fmt_write = fmt_write,
			print_set = print_set,
			s_num = s_num,
			s_lett = s_lett,
			s_fig = s_fig,
}