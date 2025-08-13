-- luajit json2txt.lua <input.json> <output.txt>

local f = io.open(arg[1], 'rb')
local s = f:read '*a'
f:close()

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

f = io.open(arg[2], 'wb')
local n = 0
for k, e, c in s:gmatch '"key"%s*:%s*"(.-)"%s*,%s*"original"%s*:%s*"(.-)"%s*,%s*"translation"%s*:%s*"(.-)"%s*[,}]' do
	f:write('> ', k, '\n')
	f:write(fmtLine(e), '\n')
	f:write(fmtLine(c), '\n\n')
	n = n + 1
end
f:close()

print('DONE! ' .. n .. ' items')
