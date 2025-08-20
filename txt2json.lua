-- luajit txt2json.lua <input.txt> <output.json>

local function parseTxt(fileName, func)
	local i, k, c, e, v = 0
	for line in io.lines(arg[1]) do
		line = line:gsub('\r+$', '')
		i = i + 1
		if not k then
			k = line:match '^> (.+)$'
			if not k and line ~= '' and not line:find '^; ' then
				error('ERROR: invalid line @ ' .. i .. ': ' .. line)
			end
		elseif not v and line:find '^; ' then
			c = line:match '^; (.+)$'
		elseif v or not line:find '^; ' then
			v = (v and (v .. '\n' .. line) or line):gsub('^"""(.-)"""', '%1')
			if not v:find '^"""' then
				if not e then
					e, v = v, nil
				else
					func(k, e, v, c)
					k, e, v, c = nil, nil, nil, nil
				end
			end
		end
	end
end

local function escape(s)
	return '"' .. s:gsub('\\', '\\\\'):gsub('\r', '\\r'):gsub('\n', '\\n'):gsub('\t', '\\t'):gsub('"', '\\"') .. '"'
end

local f = io.open(arg[2], 'wb')
f:write '[\n'
local n = 0
parseTxt(arg[1], function(k, e, v, c)
	f:write '  {\n'
	f:write('    "key": ', escape(k), ',\n')
	f:write('    "original": ', escape(e), ',\n')
	f:write('    "translation": ', escape(v))
	if c then
		f:write(',\n')
		f:write('    "context": ', escape(c), '\n')
	else
		f:write('\n')
	end
	f:write '  },\n'
	n = n + 1
end)
if n > 0 then
	f:seek('cur', -2)
	f:write '\n'
end
f:write ']\n'
f:close()

print('DONE! ' .. n .. ' items')
