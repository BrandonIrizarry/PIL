


Set = require "set"

s1 = Set.new {2, 4}
s2 = Set.new {4, 10, 2}
s3 = Set.new {4, 10, 2}
s4 = Set.new {7,8}
s5 = Set.new {4, 6}

local examples = {
	s1 <= s2,
	s1 > s2,
	s1 > s4,
}



for _, predicate in ipairs(examples) do
	print(predicate)
end

