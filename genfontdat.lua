-- luajit genfontdat.lua <fontdat.txt> <48.dat>

-- tx/y=   1/   0 tw/h= 5/32 ox/y= 5/ 8 adv=15 c=   33(!)

local function writeByte(f, v)
	if v < 0 then v = v + 0x100 end
	f:write(string.char(v))
end

local function writeShortBe(f, v)
	f:write(string.char(math.floor(v / 0x100), v % 0x100))
end

local function writeShort(f, v)
	f:write(string.char(v % 0x100, math.floor(v / 0x100)))
end

local function writeInt(f, v)
	f:write(string.char(v % 0x100, math.floor(v / 0x100) % 0x100, math.floor(v / 0x10000) % 0x100, math.floor(v / 0x1000000)))
end

local tt, n = {}, 0
for line in io.lines(arg[1]) do
	local tx, ty, tw, th, ox, oy, adv, c = line:match 'tx/y=%s*(%d+)/%s*(%d+)%s+tw/h=%s*(%d+)/%s*(%d+)%s+ox/y=%s*(%-?[%d]+)/%s*(%d+)%s+adv=%s*(%d+)%s+c=%s*(%d+)'
	c = tonumber(c)
	if tx and c <= 0xffff then
		tt[c] = {
			[1] = tonumber(tx),
			[2] = tonumber(ty),
			[3] = tonumber(tw),
			[4] = tonumber(th),
			[5] = tonumber(ox),
			[6] = tonumber(oy),
			[7] = tonumber(adv),
			[8] = c,
		}
		n = n + 1
	else
		error('ERROR: invalid line: ' .. line)
	end
end

local f = io.open(arg[2], 'wb')
f:write 'idf*'
writeShortBe(f, 48)
writeShortBe(f, 38)
writeShortBe(f, -11 + 0x10000)
writeShortBe(f, n)
for i = 0, 0xffff do
	local t = tt[i]
	if t then
		writeByte(f, t[3])
		writeByte(f, t[4])
		writeByte(f, 38 - t[6])
		writeByte(f, t[5])
		writeByte(f, t[7])
		writeByte(f, 0)
		writeShort(f, t[1])
		writeShort(f, t[2])
	end
end
for i = 0, 0xffff do
	local t = tt[i]
	if t then
		writeInt(f, t[8])
	end
end
f:close()

print 'DONE!'
