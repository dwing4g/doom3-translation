@echo off
setlocal
pushd %~dp0

@echo on

luajit txt2lang.lua base.txt base/strings/english.lang
luajit txt2lang.lua bfa.txt  base/strings/english_bfa.lang
luajit txt2lang.lua cc.txt   base/strings/english_cc.lang

@echo off

rem luajit lang2txt.lua E:\doom3bfg\base\strings\english.lang.ori base\strings\english.lang base.txt

pause
