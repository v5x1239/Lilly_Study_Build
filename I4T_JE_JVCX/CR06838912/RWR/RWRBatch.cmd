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


@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSASMDAT_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSASMDAT_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSASMDAT_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES1_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES1_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES1_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES2_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES2_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES2_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_A_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_A_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_A_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_B_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_B_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_B_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_C_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_C_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_C_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_D_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_D_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_D_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_E_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_E_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_E_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_F_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_F_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_F_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_G_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_G_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_G_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_H_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_H_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_H_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_I_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_I_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_I_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_J_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_J_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_J_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_JOTH_MEASDS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_JOTH_MEASDS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMEASDS1001_F1_MEASDSRES3_JOTH_MEASDS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTASMDAT_STRCT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTASMDAT_STRCT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTASMDAT_STRCT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES3_STRCT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES3_STRCT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES3_STRCT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES4_STRCT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES4_STRCT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES4_STRCT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES5_STRCT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES5_STRCT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSTRCT1001_F1_S1_STRCRTRES5_STRCT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F2_igSAE2001_F2_S6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F2_igSAE2001_F2_S6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F2_igSAE2001_F2_S6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S2_RSSPID2_RS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S2_RSSPID2_RS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S2_RSSPID2_RS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S3_RSSPID3_RS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S3_RSSPID3_RS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRS1001_F1_S3_RSSPID3_RS1001_F1_3.sql >> RWRBatch.log

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