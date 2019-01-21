function reload ()
  package.loaded["/home/brandon/PIL/other/descend.lua"] = nil
  dofile("/home/brandon/PIL/other/descend.lua")
end


function descend (dir)
	local dir = dir or os.getenv("HOME")
	
	local get_input = io.popen("ls -Fa " .. dir)
	
	for entry in get_input:lines() do
		print(entry)
		if entry == "PIL/" or entry == "ch14/" then
			descend(entry)
		end
	end
end

descend()
