--[[
	Exercise 17.2
	
	Rewrite the implementation of the geometric-region system
(Section 9.4) as a proper module.
]]

--[[
	Let's practice using an 'init' function for our module.
	Note that the 'init' function returns what we'd normally consider and
use as the "module itself." The init function is great, because it lets
me return/keep multiple versions of a module.

	Note: to see the images in succession, you have to close the
first application, so that the next one may open.

	See the Arch Wiki for a list of image viewers:
	
	https://wiki.archlinux.org/index.php/list_of_applications#Graphical_image_viewers
	
	Note that, on my Arch/Obarun install at least, any viewer based on Imlib2 won't
work (feh, sxiv, etc.)

	The following code assumes 'geeqie' and 'meh' are installed on your
computer; but again, the point is that YOU get to specify the image viewer.
:)
]]

local plot_init = require "plot".init

-- Preliminary definitions for southern hemisphere crescent.
local s = plot_init("geeqie", "south.pbm")
local c1 = s.shapes.disk(0,0,1)
local southern_crescent = s.transform.difference(c1, s.transform.translate(c1, 0.3, 0))
	
-- Show southern hemisphere crescent.
s.plot(southern_crescent, 500, 500)

-- Extra preliminary definitions for northern hemisphere crescent.
local t = plot_init("meh", "north.pbm")
local northern_crescent = t.transform.rotate(southern_crescent, math.pi)

-- Show northern hemisphere crescent.
t.plot(northern_crescent, 500, 500)

