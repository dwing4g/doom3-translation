-- luajit resdec.lua <input.resources> [path]

local function readInt4(f)
	local a, b, c, d = string.byte(f:read(4), 1, 4)
	return a + b*0x100 + c*0x10000 + d*0x1000000
end

local function readInt4Be(f)
	local a, b, c, d = string.byte(f:read(4), 1, 4)
	return a*0x1000000 + b*0x10000 + c*0x100 + d
end

local f = io.open(arg[1], 'rb')
if f:read(4) ~= '\xd0\0\0\x0d' then
	error('ERROR: unknown file format: ' .. arg[1])
end
local p = readInt4Be(f)
f:seek('set', p)
local fn = readInt4Be(f)
local basePath = arg[2] and (arg[2]:gsub('[/\\]+$', '') .. '/')
local t = {}
for i = 1, fn do
	local n = readInt4(f)
	local path = f:read(n):gsub('%z', '')
	p = readInt4Be(f)
	n = readInt4Be(f)
	print(string.format('%8X %9d %s', p, n, path))
	if basePath then
		path = basePath .. path
		local dir = path:gsub('/', '\\'):gsub('\\[^\\]*$', '')
		if not t[dir] then
			t[dir] = true
			os.execute('mkdir ' .. dir .. ' 2>nul')
		end
		local fo = io.open(path, 'wb')
		if not fo then
			error('ERROR: can not create file: ' .. path)
		end
		local q = f:seek()
		f:seek('set', p)
		fo:write((f:read(n)))
		fo:close()
		f:seek('set', q)
	end
end
f:close()

print('DONE! ' .. fn .. ' files')
