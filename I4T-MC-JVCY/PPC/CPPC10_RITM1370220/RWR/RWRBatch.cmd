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


@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_5.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_6.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_7.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_8.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_9.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S5_10.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_5.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_6.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_7.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_8.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_9.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S7_LBRESMD_A27_LB9F1_10.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_5.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_6.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_7.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_8.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_9.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDM2001_F1_S1_TPHASE_DM2001_F1_10.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_5.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_6.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_7.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_8.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_9.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSYST3001_F2_S1_SYSTOCCUR_SYST3F2_10.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_5.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_6.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_7.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_8.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_9.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S12_LBTEST_GLS_A27_LB9F1_10.sql >> RWRBatch.log

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