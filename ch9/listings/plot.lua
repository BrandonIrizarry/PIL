local M = {}

function M.plot (r, M, N)
	io.write("P1\n", M, " ", N, "\n") -- header
	for i = 1, N do
		local y = (N - i*2)/N -- scale y to [-1,1)
		for j = 1, M do
			local x = (j*2 - M)/M
			io.write(r(x, y) and "1" or "0"
		end
		io.write("\n")
	end
end

return M
