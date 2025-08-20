-- luajit addtxtnote.lua <base.txt>

local classes = {
	target_tip = { text_tip = '目标提示' },
	target_primaryobjective = { text = '目标标题' },
	item_objectivecomplete = { objectivetitle = '物品目标完成.标题', objectivetext = '物品目标完成.内容', inv_name = '物品目标完成.物品名' },
	item_objective = { objectivetitle = '物品目标.标题', objectivetext = '物品目标.内容', gui_parm2 = '物品目标.界面参数2', inv_name = '物品目标.物品名' },
	info_location = { name = '地点.名', location = '地点.位置', gui_parm1 = '地点.界面参数1' },

	func_door = { gui_parm1 = '门.界面参数1', gui_parm4 = '门.界面参数4' },
	func_static = { inv_name = '功能物品名', gui_parm1 = '界面参数1', gui_parm2 = '界面参数2', gui_parm3 = '界面参数3', gui_parm4 = '界面参数4', gui_parm6 = '界面参数6', gui_parm7 = '界面参数7' },
	func_mover = { gui_parm3 = 'mover功能.界面参数3', gui_parm4 = 'mover功能.界面参数4', gui_parm6 = 'mover功能.界面参数6', gui_parm7 = 'mover功能.界面参数7' },
	func_itemremove = { remove = '移除物品名' },
	func_elevator = { gui_parm3 = '电梯.界面参数3', gui_parm4 = '电梯.界面参数4', gui_parm7 = '电梯.界面参数7' },
	admin_impdoors = { gui_parm1 = 'AdminImp门界面参数1' },

	item_generic = { inv_name = '普通物品名' },
	item_default = { inv_name = '默认物品名' },
	item_medkit = { inv_name = '医疗包物品名' },
	item_medkit_small = { inv_name = '小医疗包物品名' },
	item_medkit_small_mp = { inv_name = '对战小医疗包物品名' },
	item_medkit_mp = { inv_name = '对战医疗包物品名' },
	item_armor_security = { inv_name = '护甲物品名' },
	item_armor_security_mp = { inv_name = '对战护甲物品名' },
	item_armor_shard = { inv_name = '护甲碎片物品名' },
	item_armor_shard_mp = { inv_name = '对战护甲碎片物品名' },
	item_pda = { inv_name = 'PDA物品.名', gui_parm6 = 'PDA物品.界面参数6', gui_parm7 = 'PDA物品.界面参数7' },
	item_videocd = { inv_name = '视频CD物品名' },
	item_grabbercd = { inv_name = '抢夺CD物品名' },
	item_keycard_generic = { inv_name = '钥匙卡物品名' },
	item_aircannister = { inv_name = '空气罐物品名' },
	item_artifact_tablet = { inv_name = '遗物板物品名' },
	item_key_yellow = { inv_name = '黄钥匙物品名' },
	item_keycard_aco = { inv_name = 'ACO钥匙卡物品.名', gui_parm7 = 'ACO钥匙卡物品.界面参数7' },
	item_envirosuit = { inv_name = '防辐射服物品名' },
	item_backpack = { inv_name = '对战背包物品名' },
	moveable_item_medkit = { inv_name = '可移动医疗包物品名' },
	moveable_item_medkit_small = { inv_name = '可移动小医疗包物品名' },
	moveable_item_armor_security = { inv_name = '可移动护甲物品名' },
	moveable_item_armor_shard = { inv_name = '可移动护甲碎片物品名' },
	moveable_item_aircannister = { inv_name = '可移动空气罐物品名' },
	moveable_moveable_item_armor_shard = { inv_name = '可移动护甲碎片物品名2' },
	pda_erebus4_ron_gibbons_pda = { inv_name = '特殊PDA物品名' },

	trigger_relay = { requires = '中继触发.需求', call = '中继触发.调用函数', text = '中继触发.内容' },
	target_givesecurity = { text_security = '目标安保.内容' },

	erebus2_spooked = { npc_name = '受惊NPC名' },
	erebus3_dying_marine = { npc_name = '濒死NPC名' },
	erebus3_transform_npc = { npc_name = '传送NPC名' },
	erebus6_bottech = { npc_name = '机器人NPC名' },
}

local mapfiles = {
	'maps/game/admin.map',
	'maps/game/alphalabs1.map',
	'maps/game/alphalabs2.map',
	'maps/game/alphalabs3.map',
	'maps/game/alphalabs4.map',
	'maps/game/caverns1.map',
	'maps/game/caverns2.map',
	'maps/game/comm1.map',
	'maps/game/commoutside.map',
	'maps/game/cpu.map',
	'maps/game/cpuboss.map',
	'maps/game/delta1.map',
	'maps/game/delta2a.map',
	'maps/game/delta2b.map',
	'maps/game/delta3.map',
	'maps/game/delta4.map',
	'maps/game/delta5.map',
	'maps/game/deltax.map',
	'maps/game/enpro.map',
	'maps/game/erebus1.map',
	'maps/game/erebus2.map',
	'maps/game/erebus3.map',
	'maps/game/erebus4.map',
	'maps/game/erebus5.map',
	'maps/game/erebus6.map',
	'maps/game/hell.map',
	'maps/game/hell1.map',
	'maps/game/hellhole.map',
	'maps/game/le_enpro1.map',
	'maps/game/le_enpro2.map',
	'maps/game/le_exis1.map',
	'maps/game/le_exis2.map',
	'maps/game/le_hell.map',
	'maps/game/le_hell_post.map',
	'maps/game/le_underground.map',
	'maps/game/le_underground2.map',
	'maps/game/mars_city1.map',
	'maps/game/mars_city2.map',
	'maps/game/mc_underground.map',
	'maps/game/monorail.map',
	'maps/game/phobos1.map',
	'maps/game/phobos2.map',
	'maps/game/phobos3.map',
	'maps/game/phobos4.map',
	'maps/game/recycling1.map',
	'maps/game/recycling2.map',
	'maps/game/site3.map',
	'maps/game/mp/d3ctf1.map',
	'maps/game/mp/d3ctf2.map',
	'maps/game/mp/d3ctf3.map',
	'maps/game/mp/d3ctf4.map',
	'maps/game/mp/d3dm1.map',
	'maps/game/mp/d3dm2.map',
	'maps/game/mp/d3dm3.map',
	'maps/game/mp/d3dm4.map',
	'maps/game/mp/d3dm5.map',
	'maps/game/mp/d3xpdm1.map',
	'maps/game/mp/d3xpdm2.map',
	'maps/game/mp/d3xpdm3.map',
	'maps/game/mp/d3xpdm4.map',
}

local t = {}
local used = {}
for _, mapfile in ipairs(mapfiles) do
	local f = io.open(mapfile, 'rb')
	local s = f:read '*a'
	f:close()
	local mname = mapfile:match '/([^/]+)%.map$'
	for items in s:gmatch '{([^{]+)}' do
		local cname = items:match '"classname"%s*"(.-)"'
		for tag, k in items:gmatch '"([^"]-)"%s*"(#str_.-)"' do
			local cls = classes[cname]
			if not cls then
				error('ERROR: in ' .. mname .. ' unknown class: ' .. cname .. '\n' .. items)
			end
			local v = cls[tag]
			if not v then
				error('ERROR: in ' .. mname .. ' unknown tag: ' .. tag .. '\n' .. items)
			end
			v = mname .. ':' .. v
			local n = k .. ' ' .. v
			if not used[n] then
				used[n] = true
				t[k] = (t[k] or '') .. ' ' .. v
			end
		end
	end
end

for line in io.lines 'guis.dir' do
	line = line:gsub('\\', '/')
	local f = io.open(line, 'rb')
	local s = f:read '*a'
	f:close()
	line = line:gsub('^.*/guis/', '')
	line = line:gsub('^french/', ''):gsub('^italian/', ''):gsub('^spanish/', '')
	for k in s:gmatch '(#str_[%w_]+)' do
		local n = k .. ' ' .. line
		if not used[n] and not used[n:gsub(' _ordered/', ' _common/')] then
			used[n] = true
			t[k] = (t[k] or '') .. ' ' .. line
		end
	end
end

local out, cmt = {}
for line in io.lines(arg[1]) do
	if not cmt or not line:find '^; ' then
		out[#out + 1] = line
	end
	cmt = false
	local k = line:match '^>%s*(.+)%s*$'
	if k and t[k] then
		out[#out + 1] = ';' .. t[k]
		cmt = true
	end
end
local f = io.open(arg[1], 'wb')
f:write(table.concat(out, '\n'), '\n')
f:close()

print 'DONE!'
