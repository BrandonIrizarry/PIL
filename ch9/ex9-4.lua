--[[
	Exercise 9.4

	Using our system for geometric regions, draw a waxing crescent moon as seen
from the Northern Hemisphere.
]]

--[[
	Let's look at the Southern Hemisphere example first.
The waxing crescent is on the left.
]]

local s = require "plot"

local c1 = s.shapes.disk(0,0,1)
local southern_crescent = s.transform.difference(c1, s.transform.translate(c1, 0.3, 0))

io.output("south.pbm") -- write the crescents to files.
s.plot(southern_crescent, 500, 500)

--[[
	Now, the Northern Hemisphere example should be on the right. See this wonderful
article:

	http://www.math.nus.edu.sg/aslaksen/teaching/moon.html

	Below is the required illustration of that.
]]

local northern_crescent = s.transform.rotate(southern_crescent, math.pi)
io.output("north.pbm")
s.plot(northern_crescent, 500, 500)
os.execute("feh south.pbm north.pbm") -- show both crescents.
