
function examine (dir)
	local dir = dir or os.getenv("HOME") -- default directory is /home/brandon.
	local f  = io.popen("ls -la " .. dir)
	
	for entry in f:lines() do
		local filetype_flag()
	end
end
