sample_html = [[
<html>
	<head>
		<title>
			A Simple HTML Document
		</title>
	</head>

	<body>
		<p>This is a very simple HTML document</p>
		<p>It only has two paragraphs</p>
	</body>
</html>
]]


-- Pattern only works as a literal string, unfortunately
local block = "<(.-)>(._)<(/%1)>" -- an html expression

-- Non-recursive prototype
function strip1 (expr)
	return expr:gsub("<(.-)>(.-)<(/%1)>", "%2")
end

function strip (expr)
	s = expr:gsub("<(.-)>(.-)<(/%1)>",
		function (tag1, body, tag2)
			body = strip(body) -- strip the inner contents
			return body
		end)

	return s
end

function write_result(filename, text)
	local fstream = io.open(filename, "w")
	local start = os.clock()
	local result = strip(text)
	local duration = os.clock() - start
	local message = "Time to generate result: %f seconds (%f minutes)\n%s"

	fstream:write(string.format(message, duration, duration/60, result))
end

write_result("small_example.txt", sample_html)
write_result("another_example.txt", require("another_example").text)
--write_result("big_example.txt", require("data.big_html").text)

--[[
file_simple = io.open("small_example.txt", "w")
local start = os.clock()
local result = strip(sample_html)
file_simple:write(string.format("Time to generate result: %f seconds\n%s", os.clock() - start, result))

big_text = require("data.big_html").text
file_big = io.open("big_example.txt", "w")
start = os.clock()
result = strip(big_text)
file_big:write(strip(big_text))


print(strip(sample_html))
--]]
