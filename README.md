# DOOM 3: BFG Edition 完整汉化工程

## 目前进度

- 文本: 翻译已完成, 校对中
- 字体: 测试中

## 汉化文本

- `base.txt` 提取自原版游戏中`english.lang`的英中对照格式
- `bfa.txt` 提取自BFA版非官方增强补丁中`english_bfa.lang`的英中对照格式
- `cc.txt` 提取自BFA版非官方语音字幕补丁中`english_cc.lang`的英中对照格式

## 构建方法

- 在Windows系统下, 运行`txt2lang.bat`, 会输出所有的`*.lang`到`base/strings/`中

## 汉化补丁安装方法

1. 购买安装Steam或GOG或Epic商店的原版`DOOM 3: BFG Edition`游戏本体
2. [下载覆盖最新(Nightly)的BFA版非官方增强补丁](https://github.com/MadDeCoDeR/Classic-RBDOOM-3-BFG/releases),
   Windows系统通常选择`windows-RC-retail-x64.zip`, 可能会覆盖官方版本中的`base/default.cfg`
3. 下载解压汉化字体文件到游戏文件中的`base`目录中(制作中,尚未公开)
4. 把本工程中的`base`目录, 覆盖到游戏文件中对应的`base`目录, 包含语音字幕补丁和汉化文本, 会覆盖原版和BFA增强补丁中的`base/strings/*.lang`文件

## 相关链接

- 游戏本体的Steam商店地址: https://store.steampowered.com/app/208200/DOOM_3/
- 游戏本体的GOG商店地址: https://www.gog.com/game/doom_3
- 游戏本体的Epic商店地址: https://store.epicgames.com/p/doom-3
- BFA版非官方增强补丁(包含运行游戏相关的一些说明): https://github.com/MadDeCoDeR/Classic-RBDOOM-3-BFG
- BFA版非官方语音字幕补丁: https://www.moddb.com/mods/classic-rbdoom-3-bfg-edition/downloads/full-english-subtitles-for-doom-bfa-edition
- ParaTranz上的本汉化工程: https://paratranz.cn/projects/15784
- 3DM轩辕汉化组简体中文汉化补丁(基于早期的BFG版本,无语音字幕): https://dl.3dmgame.com/patch/26635.html

## 参与汉化人员

- dwing
- Pasta Anchovy
- (如需参与, 请在 https://github.com/dwing4g/doom3-translation/issues 中提出申请)
