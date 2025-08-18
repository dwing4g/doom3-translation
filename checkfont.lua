-- chcp 65001
-- luajit checkfont.lua <input.txt> [fontdat.txt]

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

local function parseUtf8(s, func)
	local i = 1
	while i < #s do
		local b = s:byte(i)
		i = i + 1
		if b < 0x80 then
			func(b, s:sub(i-1, i-1))
		elseif b < 0xe0 then
			local b1 = s:byte(i)
			i = i + 1
			func(b % 0x20 * 0x40 + b1 % 0x40, s:sub(i-2, i-1))
		elseif b < 0xf0 then
			local b1, b2 = s:byte(i), s:byte(i + 1)
			i = i + 2
			func(b % 0x10 * 0x1000 + b1 % 0x40 * 0x40 + b2 % 0x40, s:sub(i-3, i-1))
		elseif b < 0xf8 then
			local b1, b2, b3 = s:byte(i), s:byte(i + 1), s:byte(i + 2)
			i = i + 3
			func(b % 0x8 * 0x40000 + b1 % 0x40 * 0x1000 + b2 % 0x40 * 0x40 + b3 % 0x40, s:sub(i-4, i-1))
		else
			error('invalid utf-8: ' .. s)
		end
	end
end

local t = { [0x20] = true, [0x0d] = true, [0x0a] = true }
for line in io.lines(arg[2] or '~$fontdat.txt') do
	local c = line:match 'tx/y=%s*%d+/%s*%d+%s+tw/h=%s*%d+/%s*%d+%s+ox/y=%s*%-?[%d]+/%s*%d+%s+adv=%s*%d+%s+c=%s*(%d+)'
	if c then
		t[tonumber(c)] = true
	else
		error('ERROR: invalid line: ' .. line)
	end
end

parseTxt(arg[1], function(k, e, c)
	parseUtf8(c, function(v, s)
		if not t[v] then
			-- t[v] = true
			print('WARN: undefined char: "' .. s .. '" @ ' .. k)
		end
	end)
end)

print 'DONE!'
