-- luajit lang2txt.lua <input1.lang> <input2.lang> <output.txt>

local function parseLang(fileName)
	local i, t = 0, {}
	for line in io.lines(fileName) do
		line = line:gsub('\r+$', '')
		i = i + 1
		local k, v = line:match '^[%s/]*"(.-)"%s+"(.-)"%s*$'
		if k then
			t[#t + 1] = {k, v}
			if t[k] then
				error('ERROR: duplicated key: ' .. k)
			else
				t[k] = v
			end
		elseif not line:find '^%s*//' then
			error('ERROR: invalid line ' .. i .. ': ' .. line)
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
	local k = kv[1]
	local e = kv[2]
	local c = ct[k] or e
	ct[k] = nil
	f:write('> ', k, '\n')
	f:write(fmtLine(e), '\n')
	f:write(fmtLine(c), '\n\n')
	n = n + 1
end
f:close()

for k, v in ipairs(ct) do
	if type(k) == 'string' then
		print('WARN: found extra key in "' .. arg[2] .. '": ' .. k)
	end
end

print('DONE! ' .. n .. ' items')
