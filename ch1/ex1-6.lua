--[[
  How can you check whether a value is a Boolean without using the function 'type'?
]]

function is_bool (x)
  return not(not(x)) == x
end

assert(is_bool(true) == true)
assert(is_bool(false) == true)
assert(is_bool(nil) == false)
assert(is_bool(0) == false)
assert(is_bool(is_bool) == false)
assert(is_bool("false") == false)
assert(is_bool({}) == false)