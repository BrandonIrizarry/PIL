--[[
  Exercise 4.8
  
  Redo the previous exercise so that it ignores differences in spaces and punctuation.
]]

function ispali(subj)
  
  -- Delete space (%s) and punctuation (%p) characters.
  local stripped = string.gsub(subj, "[%p%s]", "")
  
  return stripped == string.reverse(stripped)
end

local examples = {
  ispali("step on no pets"),
  ispali("banana"),
  ispali("bananab"),
  ispali("a man, a plan, a canal, panama"),
}

for _, e in ipairs(examples) do print(e) end
  