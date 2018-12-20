--[[
	NB: To test out a file (say, file.txt) as an input, you can use at the command line:

	$ echo "000kjsdk 0" > file.txt
	$ lua even_zeroes.lua < file.txt # output should be "ok"
]]

::start::

do
	local c = io.read(1)

	if c == "0" then
		goto balance -- go to the "rectification center"
	elseif c == nil then
		print "ok" -- for stdin, we hit ctrl+d; for a file, it's the EOF. Report success.
		return -- neither is there anything left to do; just leave the chunk.
	else
		goto start -- some other irrelevant character, redo this block.
	end
end

::balance::

do
	local c = io.read(1)
	if c == "0" then
		goto start -- still at even zeroes, start the process over
	elseif c == nil then
		print "not ok" -- Hit EOF on an odd number of zeroes, fail
		return -- nothing more to read, so just leave.
	else
		goto balance -- keep scanning for the balancing zero.
	end
end
