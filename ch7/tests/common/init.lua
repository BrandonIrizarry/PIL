local M = {}

package.path = package.path .. ";../../?.lua"

local sort_file = require("ex7-1").sort_file

function M.make_test(fs, infile, outfile)
	return function()
		fstream1, fstream2 = fs(infile, outfile)
		sort_file(fstream1, fstream2)
		if fstream2 ~= io.stdout then
			fstream2:flush() -- update disk
		else
			io.write("\n") -- for formatting
		end
	end
end

M.files = require "common.files"

return M
