-- luajit txt2lang.lua <input.txt> <output.lang> [1|2]

local function parseTxt(fileName, func)
	local i, k, e, v = 0
	for line in io.lines(arg[1]) do
		line = line:gsub('\r+$', '')
		i = i + 1
		if not k then
			k = line:match '^> (.+)$'
			if not k and line ~= '' and not line:find '^; ' then
				error('ERROR: invalid line @ ' .. i .. ': ' .. line)
			end
		elseif v or not line:find '^; ' then
			v = (v and (v .. '\n' .. line) or line):gsub('^"""(.-)"""', '%1')
			if not v:find '^"""' then
				if not e then
					e, v = v, nil
				else
					func(k, e, v)
					k, e, v = nil, nil, nil
				end
			end
		end
	end
end

local function escape(s)
	return '"' .. s:gsub('\\', '\\\\'):gsub('\r', '\\r'):gsub('\n', '\\n'):gsub('\t', '\\t'):gsub('"', '\\"') .. '"'
end

local f = io.open(arg[2], 'wb')
f:write '\xef\xbb\xbf{\r\n'
local n = 0
parseTxt(arg[1], function(k, e, v)
--	v = v:gsub('(%d+%-%d+)%-(214[57])', '%2-%1')
	if e:gsub('[^\n]+', '') ~= v:gsub('[^\n]+', '') then
		print('WARN: mismatch lines for key: ' .. k)
	end
	f:write('\t', escape(k), '\t', escape(arg[3] == '1' and e or v), '\r\n')
	n = n + 1
end)
f:write '}\r\n'
f:close()

print('DONE! ' .. n .. ' items')
