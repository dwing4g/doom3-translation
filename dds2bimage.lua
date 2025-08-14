-- luajit dds2bimage.lua <input_dxt1_nomip.dds> <output.bimage>

--[[
=== font bimage format:
I8 sourceFileTime: unixTimestamp(seconds)
I4 headerMagic: "\nMIB"
I4 textureType(enum textureType_t): 1(2D)
I4 format(enum textureFormat_t): 7(DXT1,4bpp)
I4 colorFormat(enum textureColor_t): 3(alpha=green)
I4 width
I4 height
I4 numLevels
{
  I4 level: [0,numLevels-1]
  I4 destZ: 0
  I4 width
  I4 height
  I4 dataSize
  u8[dataSize] data
}*numLevels

=== font dat format:
I4 magic: "idf*" ('*'=42=version)
I2 pointSize: 48
I2 ascender: 38
I2 descender: -11
I2 numGlyphs: <=0x7fff
{
  u1 width:  in image
  u1 height: in image
  i1 top:   y offset
  i1 left:  x offset
  u1 xSkip: x advance
  u1 (dummy): aligned
  u2 s: x offset in image
  u2 t: y offset in image
}*numGlyphs
u4[numGlyphs]: unicode

=== dds format:
u4: magic: "DDS "
u4: headerSize: 0x7c
u4: flags: 0x81007 (1:CAPS,2:HEIGHT,4:WIDTH,0x1000:PIXELFORMAT,0x80000:LINEARSIZE)
u4: height
u4: width
u4: pitchOrLinearSize: dataSize
u4: depth: 1
u4: mipMapCount: 1
u4[11]: reserved: 0
{
u4: pixelFormatHeaderSize: 0x20
u4: flags: 4(DDPF_FOURCC)
u4: fourCC: "DXT1"
u4: rgbBitCount: 0
u4: rBitMask: 0
u4: gBitMask: 0
u4: bBitMask: 0
u4: aBitMask: 0
}
u4: caps1: 0x1000(TEXTURE)
u4: caps2: 0
u4: caps3: 0
u4: caps4: 0
u4: reserved: 0
u8[dataSize]: data

=== dxt1 format:
u2: c0: rgb565
u2: c1: rgb565
u4: indexes: 2-bit*16
if c0>c1: 00:c0; 01:c1; 10:(c0*2+c1+1)/3; 11:(c0+c1*2+1)/3
else:     00:c0; 01:c1; 10:(c0+c1)/2;     11:transparent

=== tools:
https://github.com/GPUOpen-Tools/Compressonator
compressonatorcli -fd DXT1 -nomipmap input.png output.dds
compressonatorcli input.dds output.png
--]]

local function readInt4(f)
	local a, b, c, d = string.byte(f:read(4), 1, 4)
	return a + b*0x100 + c*0x10000 + d*0x1000000
end

local function writeIntBe(f, v)
	f:write(string.char(math.floor(v / 0x1000000), math.floor(v / 0x10000) % 0x100, math.floor(v / 0x100) % 0x100, v % 0x100))
end

local f = io.open(arg[1], 'rb')
if f:read(4) ~= 'DDS ' then
	error('ERROR: unknown file format: ' .. arg[1])
end
f:seek('set', 0xc)
local h = readInt4(f)
local w = readInt4(f)
local s = readInt4(f)
f:seek('set', 0x80)
local d = f:read(s)
f:close()

f = io.open(arg[2], 'wb')
f:write 'by dwing\nMIB'
writeIntBe(f, 1)
writeIntBe(f, 7)
writeIntBe(f, 3)
writeIntBe(f, w)
writeIntBe(f, h)
writeIntBe(f, 1)
writeIntBe(f, 0)
writeIntBe(f, 0)
writeIntBe(f, w)
writeIntBe(f, h)
writeIntBe(f, s)
f:write(d)
f:close()

print 'DONE!'
