@echo off
@if [%1]==[] goto usage
@if [%2]==[] goto usage
@if [%3]==[] goto usage
goto start
:usage
@echo RWRBatch.cmd db instance name] [UID] [PID]
@echo This file is used for InForm RWR changes, to generate MedML based on the SQL statements provided.
@echo Customers should edit this file with the appropriate SQL file names and submit with the implementation ticket..
goto end

goto start

:start
@set dbinstance=%1
@set uid=%2
@set pid=%3

cd>%TEMP%\local_dir.tmp
set OUTBOUND=%TEMP%\local_dir.tmp

@echo RWRBatch.cmd running...
@echo RWRBatch.cmd running... >> RWRBatch.log
@echo DB instance %1
@echo DB instance %1 >> RWRBatch.log
@echo UID %2
@echo UID %2 >> RWRBatch.log


@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_INJSR1001_LF1_igINJSR1001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CM2001_LF1_igCM2001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CSSBS1001_F1_igCSSBS1001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SR1001_LB9001_LF1_igSR1LB9_F1_S3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR3_HAIRF1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR20_HAIRF1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR27_HAIRF1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR33_HAIRF1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR39_HAIRF1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHAIRRFU2001_LF1_S3_HAIRRFUR46_HAIRF1_1.sql >> RWRBatch.log

@echo >> RWRBatch.log

if [%ERRORLEVEL%]==[0] @echo XMLs Generated successfully
if not [%ERRORLEVEL%]==[0] @echo **Error! XML Generation
if [%ERRORLEVEL%]==[0] @echo XMLs Generated successfully >> RWRBatch.log
if not [%ERRORLEVEL%]==[0] @echo **Error! XML Generation >> RWRBatch.log

if not [%ERRORLEVEL%]==[0] goto END

RWRXMLs.vbs %OUTBOUND%

if [%ERRORLEVEL%]==[0] @echo RWRXMLs.xml Generated successfully
if not [%ERRORLEVEL%]==[0] @echo **Error! RWRXMLs.xml Generation
if [%ERRORLEVEL%]==[0] @echo RWRXMLs.xml Generated successfully >> RWRBatch.log
if not [%ERRORLEVEL%]==[0] @echo **Error! RWRXMLs.xml Generation >> RWRBatch.log

exit /B %ERRORLEVEL%

:end