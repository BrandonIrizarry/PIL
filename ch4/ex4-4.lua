--[[
  Exercise 4.4
  
  Redo the previous exercise for UTF-8 strings:
  
  > insert("ação", 5, "!") --> ação!
  
  (Note that the position now is counted in codepoints.)
  
  Again, simply run lua on this file to see a printout.
]]

function insert(subj, pos, snippet)
  
  --[[ 
    Note that 'utf8.offset(subj, pos)' is the byte position where
    the POSth character _begins_, i.e., the position of that character's
    first byte. Hence, 'utf8.offset(subj, pos) - 1' is the byte position 
    where the POSth - 1 character _ends_, i.e., the position of the previous
    character's last byte.
    
    Note that the only change from the previous definition of this function
    is that the original 'pos' variable is now 'utf8.offset(subj, pos)', per
    the remark in the problem statement above that "the position is now
    counted in codepoints."
  ]]
  local left_side = string.sub(subj, 1, utf8.offset(subj, pos) - 1)
  local right_side = string.sub(subj, utf8.offset(subj, pos))
  
  return left_side .. snippet .. right_side
end

local str1 = "ação"
local str2 = "hello world"
local str3 = "عمل"

local examples = {
  insert(str1, 5, "!"),
  insert(str2, 1, "start: "),
  insert(str2, 7, "small "),
  insert(str3, -1, "!"), -- backwards?
  insert(str1, -1, "!")
}

for _, e in ipairs(examples) do print(e) end