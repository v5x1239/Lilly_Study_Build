@echo off
@rem -----------------------------------------------
@rem 
@rem DESCR:   This command file works with the following files and PFImport to
@rem           
@rem          
@rem          	         
@rem	      Files Used:
@rem             %trialname%_env.cmd - trial and data load specific variables
@rem -----------------------------------------------
@echo.


@set TRIALNAME=%1


@set ORACLEINSTANCE=%COMPUTERNAME%_%ORACLE_SID%
@set TRIALNAME=%TRIALNAME%
@set TRIALUID=%2
@set TRIALPID=%3
@set ORACLEINSTANCE=%4
@set COROOT=%CD%


@echo Trial:  %1% 
@echo Trial:  %1% >> SVSiteUpdate.log
if "%1"=="" @echo ** FAILURE! Missing Trial Name.
if "%1"=="" @echo ** FAILURE! Missing Trial Name. >> SVSiteUpdate.log
if "%1"=="" goto end

@echo.
@echo 1. Running SQL...
@echo 1. Running SQL... >> SVSiteUpdate.log
@echo.
@echo. >> SVSiteUpdate.log

@sqlplus -s -l %TRIALUID%/%TRIALPID%@%ORACLEINSTANCE% @SVSite.sql
@echo  Generated XMLs
@echo >> SVSiteUpdate.log

if [%ERRORLEVEL%]==[0] @echo XML Generated successfully
if not [%ERRORLEVEL%]==[0] @echo **Error! XML Generation
if [%ERRORLEVEL%]==[0] @echo XML Generated successfully >> SVSiteUpdate.log
if not [%ERRORLEVEL%]==[0] @echo **Error! XML Generation >> SVSiteUpdate.log

if not [%ERRORLEVEL%]==[0] goto END
@echo.
sleep 60
@echo.

@echo.
@echo  2. Cooking SVSite XML...
@echo  2. Cooking SVSite XML... >> SVSiteUpdate.log
@echo.
@echo. >> SVSiteUpdate.log

PFConsole -silent PFMMinst -autorun -trial %TRIALNAME% -verbose -outfile SVSiteUpdate.log -xml SVSite.xml
@echo Cooking the SVSite xml  >> SVSiteUpdate.log
@echo >> SVSiteUpdate.log

@echo.

:end