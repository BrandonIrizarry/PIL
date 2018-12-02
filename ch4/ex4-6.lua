--[[
  Exercise 4.6
  
  Redo the previous exercise for UTF-8 strings:
  
  > remove("ação", 2, 2) --> ao
  
  (Here, both the initial position and the length should be counted in codepoints.)
]]

function remove(subj, start, width)

  --[[
    Here, we want the bytes up to the end of the last character on the left
    side, and resume on the first byte of the START + WIDTH character.
  ]]
  local left_side = string.sub(subj, 1, utf8.offset(subj, start) - 1)
  local right_side = string.sub(subj, utf8.offset(subj, start + width))
  
  return left_side .. right_side
end

local examples = {
  remove("ação", 2, 2),
}

for _, e in ipairs(examples) do print(e) end