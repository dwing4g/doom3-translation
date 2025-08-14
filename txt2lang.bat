@echo off
setlocal
pushd %~dp0

@echo on

luajit txt2lang.lua base.txt base/strings/english.lang
luajit txt2lang.lua bfa.txt  base/strings/english_bfa.lang
luajit txt2lang.lua cc.txt   base/strings/english_cc.lang

pause
