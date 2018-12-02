--[[
  Exercise 4.9
  
  Redo the previous exercise for UTF-8 strings.
]]

-- Function for computing the ith codepoint of
-- a Unicode string.
function codepoint_at_pos(subj, pos)
  return utf8.codepoint(subj, utf8.offset(subj, pos))
end


function ispali(subj)

  -- Strip the subject of spaces and punctuation.
  local subj = string.gsub(subj, "[%p%s]", "")
  local L = utf8.len(subj)
  
  for i = 1, L do
    local K = L + 1 -- used to compute the char to pair up with
    if codepoint_at_pos(subj, i) ~= codepoint_at_pos(subj, K - i) then
      return false
    end
  end
  
  return true
end

local examples = {
  ispali(""),
  ispali("aba"),
  ispali("step on no pets"),
  ispali("banana"),
  ispali("a man, a plan, a canal, panama"),
  ispali("о, гомін німого"),
}

for _, e in ipairs(examples) do print(e) end