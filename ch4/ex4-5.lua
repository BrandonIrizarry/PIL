--[[
  Exercise 4.5
  
  Write a function to remove a slice from a string; the slice should be given by its initial
  position and its length:
  
  > remove("hello world", 7, 4)) --> hello d
  ]]
  
  function remove(subj, start, width)
    
    local left_side = string.sub(subj, 1, start - 1)
    local right_side = string.sub(subj, start + width)
    
    return left_side .. right_side
  end
  
  local examples = {
    remove("hello world", 7, 4),
  }
  
  for _, e in ipairs(examples) do print(e) end