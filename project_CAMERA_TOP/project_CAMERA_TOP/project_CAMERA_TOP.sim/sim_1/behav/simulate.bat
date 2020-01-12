@echo off
set bin_path=D:\\Mathlogic\\modelsim\\win32pe
call %bin_path%/vsim   -do "do {CAMERE_TOP_simulate.do}" -l simulate.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
