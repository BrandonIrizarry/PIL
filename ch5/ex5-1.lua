--[[
	Exercise 5.1
	What will the following script print? Explain.
]]

sunday = "monday"; monday = "sunday"
t = {sunday = "monday", [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])

-- Note that the above can be expressed as
t = {["sunday"] = "monday", ["monday"] = "sunday"}
print(t["sunday"], t["monday"], t[t["sunday"]])

-- From there it's a little easier to figure out :)
