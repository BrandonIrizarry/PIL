function allwords ()
	local line = io.read() 	-- current line
	local pos = 1 			-- current position in the line
	local line_no = 1
	--print("First line.")
	
	return function ()		-- iterator function
		while line do 		-- repeat while there are lines
			local w, e = string.match(line, "(%w+)()", pos)
			if w then 		-- found a word
				pos = e		-- next position to scan from is after this word
				return w	-- return the word
			else
				print("End of line #: ", line_no)
				line_no = line_no + 1
				
				line = io.read()	-- word not found; try next line
				pos = 1				-- restart from first position
			end
		end
		
		return nil 		-- done.
	end
end

io.input(arg[1] or io.stdin)
for word in allwords() do print(word) end