local this_print, this_sin = print, math.sin

_ENV = nil -- cierra la tienda

this_print(13)
this_print(this_sin(13))
--this_print(math.cos(13))

print(_G.print)