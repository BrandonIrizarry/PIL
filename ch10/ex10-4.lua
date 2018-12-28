--[[
	Exercise 10.4

	At the end of Section 10.3, we defined a 'trim' function. Because of its use of
backtracking, this function can take a quadratic time for some strings. (For instance,
in my new machine, a match for a 100 KB string can take 52 seconds.)

- Create a string that triggers this quadratic behavior in function 'trim'.
- Rewrite that function so that it always works in linear time.
]]

function trim (s)
	s = string.gsub(s, "^%s*(.-)%s*$", "%1")
	return s
end

-- Test 'trim' (especially for certain tricky strings.)
function run_benchmark (str, trimmer)
	local trimmer = trimmer or trim
	local start = os.clock()
	trimmer(str)
	local finish = os.clock() - start
	print(string.format("Operation took %f seconds (%f minutes).", finish, finish / 60))

end

spaces_100KB = string.rep(" ", 100 * 2^10) -- 100 KB of spaces
spaces_50KB = string.rep(" ", 50 * 2^10) -- 50 KB of spaces

tests = {
			"a" .. spaces_100KB .. "a", -- 2 1/2 mins
			"a" .. spaces_50KB .. "a" .. spaces_50KB .. "a", -- 1.3 mins
		}

--[[
	It looks like 'trim' has trouble finding its middle block. It matches the
first "zero or more" spaces until it sees the first non-space character. Then,
it starts to match the middle block; it does that OK, then sees another run
of spaces, until it hits another non-space character, meaning that the run of
spaces was a false positive. Then, it backtracks to the beginning of the middle
block, then includes the first space as part of that block, then sees the second
space, then sees that run of spaces, and hits the same false positive again.
It then backtracks to the start of the middle block again, and extends that block to
include the second space... Eventually, it correctly defines the middle block as
including that last set of "foil" characters, and finishes by matching whatever spaces
there are at the end.
]]

-- Doesn't trim something like "  a     a  ". tbc, fix.
-- May need something a little more involved than just a one-liner w/ pattern. :)
function trim_fast (s)
	s = string.gsub(s, "^%s*(%S*)%s*$", "%1")
	return s
end

run_benchmark(tests[1], trim_fast)
