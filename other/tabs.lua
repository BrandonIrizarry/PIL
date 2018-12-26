
content = [[
A	qt	!
so	hi
I	wanna c
ry!
]]

output = assert(io.open("data/expand.txt", "a"))

-- Returns a tab-expanded string, taking into account newlines.
function expandTabs (s, tab)
	tab = tab or 4 -- tab size (default is 4)
	local corr = 0 -- correction ()
	local line_chars = 0 -- total number of characters seen on previous lines, after expansion.
	s = string.gsub(s, "()([\t\n])", function (p, special)

			local tab_col = p - 1 + corr - line_chars

			if special == "\t" then
				local sp = tab - tab_col % tab
				corr = corr - 1 + sp
				return string.rep(" ", sp)
			elseif special == "\n" then
				-- 'tab_col + 1' is the number of chars, after expansion, on
				-- the line ended by this newline character.
				line_chars = line_chars + tab_col + 1
			end
		end)
	return s
end


function unexpandTabs (s, tab)
	tab = tab or 4
	s = PIL.expandTabs(s, tab) -- need char pos <=> tab stop col pos
	local pat = string.rep(".", tab)
	s = string.gsub(s, pat, "%0\1")
	s = string.gsub(s, " +\1", "\t")
	s = string.gsub(s, "\1", "")
	return s
end


output:write("\n\n", expandTabs(content))

