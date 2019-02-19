--[[
	Exercise 18.3
	
	Write an iterator 'uniquewords' that returns all words from a given
file without repetitions. (Hint: start with the 'allwords' code in Listing
18.1; use a table to keep all words already reported.
]]

function allwords ()
	local line = io.read() 	-- current line
	local pos = 1 			-- current position in the line
	--local line_no = 1

	local exists = {} -- a table to keep all words already reported
	
	return function ()		-- iterator function
		while line do 		-- repeat while there are lines
			local w, e = string.match(line, "(%w+)()", pos)
			
			if w then 		-- found a word
				if not exists[w] then -- found a new word
					pos = e		-- next position to scan from is after this word
					exists[w] = true -- record it as having been found 
					return w	-- return the word
				else
					pos = e
				end
			else
				line = io.read()	-- word not found; try next line
				pos = 1				-- restart from first position
			end
		end
		
		return nil 		-- done.
	end
end

function test ()
	io.input(arg[1] or io.stdin)
	for word in allwords() do print(word) end
end