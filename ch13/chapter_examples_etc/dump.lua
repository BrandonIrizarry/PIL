--[[
	string.pack serializes data into a string, and string.unpack
unserializes it.
	The following program assumes that its input is byte-serialized data;
it unserializes the input into raw bytes.
]]

local filler = "__ "

local f = assert(io.open(arg[1], "rb"))
local blocksize = 16

for block in f:lines(blocksize) do
	for i = 1, #block do
		local char = string.unpack("B", block, i) -- read in block byte by byte.
		io.write(string.format("%02X ", char)) -- dump the unpacked raw byte.
	end

	-- For most blocks, 'blocksize - #block' is zero; but the last block
	-- is likely less than 'blocksize' bytes long.
	io.write(string.rep(filler, blocksize - #block))

	-- Display the block-text next to its dump
	block = string.gsub(block, "%c", ".") -- this nullifies the effect of control chars on printing.
	io.write(" ", block, "\n")
end
