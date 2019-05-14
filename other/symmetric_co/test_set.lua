Set = require "set"

function test1 ()
	local set = Set:new()
	
	set:add "Horace"
	set:add "Catullus"
	local t1 = set.size == 2
	
	set:remove "Vergil"
	local t2 = set.size == 2
	
	set:remove "Horace"
	set:remove "Catullus"
	local t3 = set.size == 0
	
	set:remove "Catullus"
	local t4 = set.size == 0
	
	return t1 and t2 and t3 and t4
end
	
print(test1())

function test2 ()
	local set = Set:new {"Bach", "Mozart", "Haydn"}
	set:remove "Beethoven"
	
	local t1 = set.size == 3
	
	return t1
end

