
local function init (image_viewer, outfile_name)

	local out = assert(io.open(outfile_name, "w")) or io.stdout
	
	
	local function plot (r, M, N)
		out:write("P1\n", M, " ", N, "\n") -- header
		
		for i = 1, N do
			local y = (N - i*2)/N -- scale y to [-1,1)

			for j = 1, M do
				local x = (j*2 - M)/M
				out:write(r(x, y) and "1" or "0")
			end
			out:write("\n")
		end
		
		os.execute(string.format("%s %s", image_viewer, outfile_name))
	end
	
	return {
		shapes = require "plot.shapes",
		transform = require "plot.transform",
		plot = plot,
	}
end

return { init = init }
