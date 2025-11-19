-- luajit openai_gemini.lua openai_gemini.trans.lua 输入.txt 输出.txt
url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent'
openai_api_key = dofile '~$gemini_key.lua' -- return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
temperature = 0
top_k = 20
top_p = 0.95
max_tokens = -1
debug = nil
jsonHighSize = 64 * 1024
jsonLowSize = jsonHighSize * 0.99
lineLimitSize = jsonHighSize * 0.2 -- for batch mode
thinking = 3000
prompt = [[
你是精通英文到中文翻译的好助手，下面将要翻译我每次提供的英文原文。
原文出自一款科幻类游戏《DOOM3》中的对话和提示信息，相邻两行原文可能上下文相关，以帮助理解每句话的含义。
你会理解原文每个词的含义，译文要遵循原文的风格和语气，调整用词、语序和标点以符合通顺自然的中文习惯，还要保证专有名词和术语的一致性，人名单词也要音译。
可以先简要分析一下原文的翻译要点，最后把完整的简体中文译文用```前后括起来输出，其中每行译文要跟每行原文保持一一对应，行数一致。
]]

local tree = {}
local i = 0
local f --= io.open 'terms.csv'
if f then
	f:close()
	for line in io.lines 'terms.csv' do
		i = i + 1
		local term, tran = line:match '^[%[%]%d]*"(.-)","(.-)",'
		if not term then
			term, tran = line:match '^[%[%]%d]*(.-),(.-),'
			if not term then
				error('ERROR: invalid line in terms.csv at line ' .. i)
			end
		end
		local node = tree
		for word in term:gsub('%W+', ' '):lower():gmatch '%w+' do
			local n = node[word]
			if not n then
				n = {}
				node[word] = n
			end
			node = n
		end
		if node == tree then
			error('ERROR: empty term at line ' .. i)
		end
		if node[1] then
			error('ERROR: duplicated terms: "' .. node[1] .. '" and "' .. term .. '"')
		end
		node[1] = term
		node[2] = tran
	end
end

local lineCount, empties
filter_line_in = function(line, i)
	return line
end
filter_lines_in = function(lines, i)
	empties = {}
	local i = 0
	lineCount = 0
	for line in lines:gmatch '(.-)\n' do
		i = i + 1
		if line:find '^%s*$' then
			empties[i] = true
		else
			lineCount = lineCount + 1
		end
	end
	local words = {}
	for word in lines:gsub('%W+', ' '):lower():gmatch '%w+' do
		words[#words + 1] = word
	end
	local pres, set = {}, {}
	for i = 1, #words do
		local node, best = tree, nil
		for j = i, #words do
			node = node[words[j]]
			if not node then
				if best then
					local term = best[1]
					if not set[term] then
						set[term] = true
						if #pres == 0 then
							pres[1] = '专有名词的参考翻译:\n'
						end
						pres[#pres + 1] = term
						pres[#pres + 1] = '=>'
						pres[#pres + 1] = best[2]
						pres[#pres + 1] = '\n'
					end
				end
				break
			end
			if node[1] then
				best = node
			end
		end
	end
	local pre = table.concat(pres)
	io.write(utf8_local(pre))
	return pre .. '英文原文:\n' .. lines:gsub('%s*\n', '\n')
end
filter_line_out = function(res, i)
	local trans = {}
	local all, tran = res:gsub('^<think>.-</think>', ''):gsub('\r', ''):match '(```.-\n(.-)```)'
	local tran, n = tran:gsub('%s*\n', '\n')
	if n ~= lineCount then
		local msg = 'WARN: {{{ mismatched line count: ' .. n .. ' != ' .. lineCount .. '\n'
		io.write(msg)
		trans[1] = msg
	end
	i = 0
	for line in tran:gmatch '(.-)\n' do
		i = i + 1
		while empties[i] do
			i = i + 1
			trans[#trans + 1] = '\n'
		end
		trans[#trans + 1] = line
		trans[#trans + 1] = '\n'
	end
	while empties[i + 1] do
		i = i + 1
		trans[#trans + 1] = '\n'
	end
	if n ~= lineCount then
		trans[#trans + 1] = 'WARN: }}} mismatched line count: ' .. n .. ' != ' .. lineCount .. '\n'
	end
	lineCount = 0
	return all, table.concat(trans)
end

-- 1. 对每个原文txt文件用AI提取每行的专有名词表并翻译,生成对应该文件的专有名词文件.
-- 2. 取出所有专有名词文件中的专有名词表,合并相同词,排序,生成完整词库文件.
-- 3. 人工校对并修改完整词库文件.
-- 4. 参考修正的完整词库文件,对每个原文txt文件用AI翻译每行文字,生成翻译后的译文txt文件.
