Echo off

:: ***************************************************************************
::     PFImport.cmd                                                
::     Usage: PFImport.cmd <trial_name> <trial DB UID> <trial DB PID> <connection string>                                        
::     Author - P, Pandiarajan		09-Jun-2014     To execute the SQL file Import.sql and import the xml generated from SQL using PF Import tool. 
:: ****************************************************************************

@set InForm_Trial=%1
@set TrialDBuid=%2
@set TrialDBpid=%3
@set InFormTrialDBinstance=%4

IF '%InForm_Trial%' == '' ECHO Provide proper trial name
IF '%TrialDBuid%' == '' ECHO Provide proper trial database user id
IF '%TrialDBpid%' == '' ECHO Provide proper trial database password
IF '%InFormTrialDBinstance%' == '' ECHO Provide proper oracle connection string


@ECHO   --------------------------------------------------------------------------- 
@ECHO    1. SPOOLING Import_WFRULETRIG.xml                         
@ECHO   --------------------------------------------------------------------------- 

sqlplus %TrialDBuid%/%TrialDBpid%@%InFormTrialDBinstance% @Import_WFRULETRIG.sql

@ECHO   --------------------------------------------------------------------------- 
@ECHO    SPOOLING Import_WFRULETRIG.xml Completed                        
@ECHO   --------------------------------------------------------------------------- 


IF NOT EXIST Import_WFRULETRIG.xml (
	@ECHO   **FAILURE! Import.xml NOT FOUND IN THE WORKING DIRECTORY** 
	@ECHO   **FAILURE! Import.xml NOT FOUND IN THE WORKING DIRECTORY**       
	GOTO END)
	
@ECHO   --------------------------------------------------------------------------- 
@ECHO    2. Adding PFImport User                         
@ECHO   --------------------------------------------------------------------------- 

pfconsole pfmminst -trial %InForm_Trial% -verbose -autorun -outfile PFImport_Active.log -xml PfImport_Active.xml

@ECHO   --------------------------------------------------------------------------- 
@ECHO    PfImport User Added                        
@ECHO   --------------------------------------------------------------------------- 

@ECHO   --------------------------------------------------------------------------- 
@ECHO    3. Associate PFImport User to All sites                        
@ECHO   --------------------------------------------------------------------------- 

sqlplus %TrialDBuid%/%TrialDBpid%@%InFormTrialDBinstance% @User_Site.sql

pfconsole pfmminst -trial %InForm_Trial% -verbose -autorun -outfile Site_User_Association.log -xml User_Site.xml

@ECHO   --------------------------------------------------------------------------- 
@ECHO    User Site Association completed                       
@ECHO   --------------------------------------------------------------------------- 

@ECHO   --------------------------------------------------------------------------- 
@ECHO    3. IMPORTING Import_WFRULETRIG.xml generated                         
@ECHO   --------------------------------------------------------------------------- 

	
pfconsole pfimport -autorun -verbose -trial %InForm_Trial% -norules -user PFImport1 -password PFImport12345 -xml Import_WFRULETRIG.xml -output PFImport_WFRULETRIG.log

@ECHO   --------------------------------------------------------------------------- 
@ECHO    IMPORTING Import.xml is completed. Please verify Output.log file for output.                         
@ECHO   --------------------------------------------------------------------------- 
@ECHO.

@ECHO   --------------------------------------------------------------------------- 
@ECHO    4. Terminating PFImport User                         
@ECHO   --------------------------------------------------------------------------- 

pfconsole pfmminst -trial %InForm_Trial% -verbose -autorun -outfile PFImport_Terminate.log -xml PfImport_Terminate.xml

@ECHO   --------------------------------------------------------------------------- 
@ECHO    PfImport User Terminated                        
@ECHO   --------------------------------------------------------------------------- 

GOTO :eof

:eof