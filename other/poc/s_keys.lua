
-- Return a sequence of the table's keys, fixed to be valid.
-- Needs: force_valid_key, glossary, keywords, make_printable, 
-- LUA_IDENTIFIER.
-- Preserve depth. Idea: set all fields to 'true'.

function serialize_keys (t)
	