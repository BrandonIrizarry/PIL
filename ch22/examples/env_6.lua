
-- Make _G reference back to _ENV, as when Lua first starts up.
-- This is what I really wanted to do, to clarify the relationship
-- between _G and _ENV.
_ENV = {this_print = print}
_G = _ENV

a = 4

this_print(_ENV["a"])
this_print(_G["a"])