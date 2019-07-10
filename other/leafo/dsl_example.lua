
local function setfenv (fn, env)
	local idx = 1
	
	repeat
		local name = debug.getupvalue(fn, idx)
		if name == "_ENV" then
			debug.upvaluejoin(fn, idx, function() return env end, 1)
			break
		end
		idx = idx + 1
	until name == nil
	
	return fn
end

local function getfenv (fn)
	local idx = 1
	
	repeat
		local name, val = debug.getupvalue(fn, idx)
		if name == "_ENV" then
			return val
		end
		idx = idx + 1
	until name == nil
end

local function run_with_env (env, fn, ...)
	setfenv(fn, env)
	fn(...)
end

local dsl_env = {
	move = function (x,y)
		print("I moved to", x, y)
	end,
	
	speak = function (message)
		print("I said", message)
	end,
	
	print = print,
}

local dsl_env2 = {
	move = function (x, y)
		print("The product is", x * y)
	end,
	
	speak = function (message)
		print("This is yet another message:", message)
	end
}

run_with_env(dsl_env, function (msg)
	move(10, 10)
	speak("I am hungry!")
	print(msg)
end, "End of program.")

run_with_env(dsl_env2, function ()
	move(10, 10)
	speak("I am hungry!")
end)

--[[
local function render_html (fn) -- fn is a thunk that "hosts" the environment we want
	setfenv(fn, setmetatable({}, {
		__index = function(_, tag_name)
			return function(opts)
				return build_tag(tag_name, opts)
			end
		end
	}))
	
	-- later: _ => env_table (the metatable's _client_); env_table[tag_name] = generated_function.
	return fn() -- pump the thunk
end
--]]

local void_tags = {
	img = true,
}

local function append_all (buffer, ...)
	for i = 1, select("#", ...) do
		table.insert(buffer, (select(i, ...)))
	end
end

local function build_tag(tag_name, opts)
	local buffer = {"<", tag_name}
	if type(opts) == "table" then
		for k,v in pairs(opts) do
			if type(k) ~= "number" then
				append_all(buffer, " ", k, '="', v, '"')
			end
		end
	end
	
	if void_tags[tag_name] then
		append_all(buffer, " />") -- finish the tag
	else
		append_all(buffer, ">") -- opening tag
		if type(opts) == "table" then
			print(tag_name, "was table")
			print(table.unpack(opts)) -- nb: table.unpack only unpacks the sequence (i.e. the element's contents)
			append_all(buffer, table.unpack(opts))
		else
			print(tag_name, "was not table")
			print(opts)
			append_all(buffer, opts)
		end
		append_all(buffer, "</", tag_name, ">")
	end
	
	return table.concat(buffer)
end

local function render_html (fn) -- fn is a thunk that "hosts" the environment of 'div', 'img', 'html', etc.
	setfenv(fn, setmetatable({}, {
		__index = function(env_table, tag_name)
			dsl_fn = function(opts)
				return build_tag(tag_name, opts)
			end
			
			-- Cache the generated function in the environment table ("officially include it in the environment.")
			env_table[tag_name] = dsl_fn
			
			return dsl_fn
		end
	}))
	
	return fn() -- pump the thunk
end

local unsafe_text = [[<script type="text/javascript">alert('hacked!')</script>]]


local results = {}

results[1] = render_html(function ()
	return div(unsafe_text)
end)

results[2] = render_html(function ()
	return html {
		body {
			h1 "Welcome to my Lua site",
			a {
				href = "http://leafo.net",
				"Go home"
			}
		}
	}
end)

--[[
for _, v in ipairs(results) do
	print(v)
end
]]



