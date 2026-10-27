@echo off
set DEV=%~dp0
set PATH=%DEV%flutter\bin;%PATH%
set PUB_CACHE=%DEV%pub-cache
flutter --version
start "" "%DEV%vscode\Code.exe"
