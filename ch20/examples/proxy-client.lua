local tracker = require "proxy"

local track = tracker.track

local t = {} -- we'll track additions and access to this table.

t = track(t) -- cleverly substitute t with its proxy.

t[2] = "hello"
print(t[2])

local q = {} -- what if we try to track another table?

q = track(q)

q[2] = "good morning"

for k,v in pairs(t) do
	print(k,v)
end
