function foo (str)
	if type(str) ~= "string" then
		error("string expected")
	end
	
	print(str)
end

foo("hello")
foo({})

function bar (str)
	if type(str) ~= "string" then
		error("string expected", 2)
	end
	
	print(str)
end

bar("goodbye")
bar({})