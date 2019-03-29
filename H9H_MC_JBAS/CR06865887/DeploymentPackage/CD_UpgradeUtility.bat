@echo off

if [%3] == [] goto :usage

set trial=%1
set trialUid=%2
set trialPid=%3
set dbInstance=%4

if [%dbInstance%] == [] set dbInstance=trial1

set xmlFile=Trial_FormSection.xml
set msg=Completed Successfully.

call sqlplus -L %trialUid%/%trialPid%@%dbInstance% @RWR.sql %xmlFile% || goto :error
pfadmin stop trial %trial%

pause

call pfMMInst.exe -trial %trial% -outfile setup.log -verbose -autorun -xml %xmlFile% || goto :error
pfadmin start trial %trial%
goto :end


:usage
echo.
echo  Syntax: %0 [Trial] [Trial UID] [Trial PID] [DBInstance]
echo.
echo.
exit /b 0

:error
set msg=Failed with error # %errorlevel%.

:end
del /Q /F %xmlFile% 2>nul 1>nul
del /Q /F setup.log 2>nul 1>nul
echo %0 %msg%.
exit /b 0

