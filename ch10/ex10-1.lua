--[[
	Exercise 10.1

	Write a function 'split' that receives a string and a delimiter pattern
and returns a sequence with the chunks in the original string separated by
the delimiter:

	t = split("a whole new world", " ")
	-- t = {"a", "whole", "new", "world"}

	How does your function handle empty strings? (In particular, is an empty string
an empty sequence or a sequence with one empty string?)
]]

--[[
	Our function processes an empty string into an empty sequence.
This is because tokens are added to the table only when gsub finds a match.
]]

function split (str, pat, lit)

	-- Escape magic characters if 'lit' is 'true'
	if lit then
		pat = pat:gsub("%W", "%%%0") -- see p. 102
	end

	local blocks = {}
	local last = 1 -- default value (sole token is 'str' itself)

	str:gsub("(.-)"..pat.."()", function (block, index)
		if #block > 0 then -- reject "" (e.g. pat begins string, or pat is "")
			blocks[#blocks + 1] = block
		end
		last = index -- aim to collect the index of the last block
	end)

	if last <= #str -- guard against 'sub' returning ""
		then blocks[#blocks + 1] = str:sub(last)
	end

	return blocks
end


function test ()
	local cases =
		{
			{"hello+++goodbye",				"+++", 		true},
			{"hello", 						".", 		true},
			{"+++hello+++",					"+++", 		true},
			{"", 							"h", 			},
			{"househouse", 					"o",			},
			{"househouse", 					"z",			},
			{"these are words", 			" ",			},
			{"pan123_can456", 				"%W",			},
			{"867-5309", 					"-",			},
			{".This;is.some thing!new?", 	"[;.!? ]",		},
			{"Holland",						"",				}
		}

	for _, c in ipairs(cases) do
		local str, pat, lit = c[1], c[2], c[3]
		local blocks = split(str, pat, lit)
		io.write(string.format('string: "%s"\npattern: "%s", %s\ntokens: ', str, pat, tostring(lit or false))
		)
		for _, block in ipairs(blocks) do
			io.write(block, " ")
		end
		io.write("\n\n")
	end
end

test()


