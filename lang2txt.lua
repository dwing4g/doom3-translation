-- luajit lang2txt.lua <input1.lang> <input2.lang> <output.txt>

local function parseLang(fileName)
	local i, t, c = 0, {}
	for line in io.lines(fileName) do
		line = line:gsub('\r+$', '')
		if line:find '^\xef\xbb\xbf' then
			line = line:sub(4, -1)
		end
		i = i + 1
		local k, v = line:match '^[%s/]*"(.-)"%s+"(.-)"%s*$'
		if k then
			t[#t + 1] = {k, v, c}
			if t[k] then
				error('ERROR: duplicated key: ' .. k)
			else
				t[k] = {v, c}
			end
			c = nil
		else
			c = line:match '^%s*//%s*(.+)%s*$'
			if not c and not line:find '^%s*[{}]%s*$' then
				error('ERROR: invalid line ' .. i .. ': ' .. line)
			end
		end
	end
	return t
end

local function fmtLine(line)
	local escapeMark = '@@EsCaPeMaRk##'
	if line:find(escapeMark) then
		error('ERROR: found escape string for line: ' .. line)
	end
	local s = line:gsub('\\\\', escapeMark)
				  :gsub('\\t', '\t')
				  :gsub('\\r', '\r')
				  :gsub('\\n', '\n')
				  :gsub('\\"', '"')
				  :gsub("\\'", "'")
	if s:find '\\' then
		error('ERROR: found unknown escape for line: ' .. line)
	end
	s = s:gsub(escapeMark, '\\')
	if s:find '"""' then
		error('ERROR: found multi-line quot for line: ' .. line)
	end
	if s:find '[\r\n]' or s == '' then
		s = '"""' .. s .. '"""'
	end
	return s
end

local et = parseLang(arg[1])
local ct = parseLang(arg[2])

local f = io.open(arg[3], 'wb')
local n = 0
for i, kv in ipairs(et) do
	local k, e, c = kv[1], kv[2], kv[3]
	local v = ct[k] and ct[k][1] or e
	c = ct[k] and ct[k][2] or c
	ct[k] = nil
	f:write('> ', k, '\n')
	if c then
		f:write('; ', c, '\n')
	end
	f:write(fmtLine(e), '\n')
	f:write(fmtLine(v), '\n\n')
	n = n + 1
end
f:close()

for k, v in ipairs(ct) do
	if type(k) == 'string' then
		print('WARN: found extra key in "' .. arg[2] .. '": ' .. k)
	end
end

print('DONE! ' .. n .. ' items')
