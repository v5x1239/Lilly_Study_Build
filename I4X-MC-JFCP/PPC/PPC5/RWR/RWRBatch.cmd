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


@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F1_igEX1001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F1_igEX1001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F1_igEX1001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F1_igEX1001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F4_igEX1001_F4_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F4_igEX1001_F4_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F4_igEX1001_F4_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F4_igEX1001_F4_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F3_igEX1001_F3_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F3_igEX1001_F3_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F3_igEX1001_F3_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F3_igEX1001_F3_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F5_igEX1001_F5_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F5_igEX1001_F5_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F5_igEX1001_F5_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F5_igEX1001_F5_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F6_igEX1001_F6_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F6_igEX1001_F6_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F6_igEX1001_F6_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_F6_igEX1001_F6_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_VS1001_F3_igVS1001_F3_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_VS1001_F3_igVS1001_F3_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_VS1001_F3_igVS1001_F3_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_VS1001_F3_igVS1001_F3_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE4001_F2_igAE4001_F2_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE4001_F2_igAE4001_F2_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE4001_F2_igAE4001_F2_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE4001_F2_igAE4001_F2_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_HO2001_F1_igHO2001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_HO2001_F1_igHO2001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_HO2001_F1_igHO2001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_HO2001_F1_igHO2001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S7_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S7_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S7_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_F1_igSAE2001_F1_S7_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_TRF3001_F1_igTRF3001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_TRF3001_F1_igTRF3001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_TRF3001_F1_igTRF3001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_TRF3001_F1_igTRF3001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_F1_S1_VISDAT_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_F1_S1_VISDAT_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_F1_S1_VISDAT_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_F1_S1_VISDAT_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSSTDAT_DS1001_F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSSTDAT_DS1001_F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSSTDAT_DS1001_F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSSTDAT_DS1001_F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSDECOD_DS1001_F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSDECOD_DS1001_F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSDECOD_DS1001_F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F2_S1_DSDECOD_DS1001_F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F1_S1_EXOCCUR_EX1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F1_S1_EXOCCUR_EX1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F1_S1_EXOCCUR_EX1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F1_S1_EXOCCUR_EX1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXOCCUR_EX1001_F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXOCCUR_EX1001_F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXOCCUR_EX1001_F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXOCCUR_EX1001_F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F3_S1_EXOCCUR_EX1001_F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F3_S1_EXOCCUR_EX1001_F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F3_S1_EXOCCUR_EX1001_F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F3_S1_EXOCCUR_EX1001_F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXOCCUR_EX1001_F5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXOCCUR_EX1001_F5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXOCCUR_EX1001_F5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXOCCUR_EX1001_F5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F6_S1_EXOCCUR_EX1001_F6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F6_S1_EXOCCUR_EX1001_F6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F6_S1_EXOCCUR_EX1001_F6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F6_S1_EXOCCUR_EX1001_F6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1001_F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1001_F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1001_F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1001_F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSDECOD_DS1001_F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSDECOD_DS1001_F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSDECOD_DS1001_F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSDECOD_DS1001_F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEEXDOSDAT_SAE2001_F1_S3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEEXDOSDAT_SAE2001_F1_S3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEEXDOSDAT_SAE2001_F1_S3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEEXDOSDAT_SAE2001_F1_S3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEAEACN_SAE2001_F1_S3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEAEACN_SAE2001_F1_S3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEAEACN_SAE2001_F1_S3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S3_SAEAEACN_SAE2001_F1_S3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEEXDOSDAT_SAE2001_F1_S4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEEXDOSDAT_SAE2001_F1_S4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEEXDOSDAT_SAE2001_F1_S4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEEXDOSDAT_SAE2001_F1_S4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEAEACN_SAE2001_F1_S4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEAEACN_SAE2001_F1_S4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEAEACN_SAE2001_F1_S4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S4_SAEAEACN_SAE2001_F1_S4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEEXDOSDAT_SAE2001_F1_S5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEEXDOSDAT_SAE2001_F1_S5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEEXDOSDAT_SAE2001_F1_S5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEEXDOSDAT_SAE2001_F1_S5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEAEACN_SAE2001_F1_S5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEAEACN_SAE2001_F1_S5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEAEACN_SAE2001_F1_S5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S5_SAEAEACN_SAE2001_F1_S5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S1_LBDAT_LB9001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S1_LBDAT_LB9001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S1_LBDAT_LB9001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F1_S1_LBDAT_LB9001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F2_S1_LBDAT_LB9001_F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F2_S1_LBDAT_LB9001_F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F2_S1_LBDAT_LB9001_F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F2_S1_LBDAT_LB9001_F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F3_S1_LBDAT_LB9001_F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F3_S1_LBDAT_LB9001_F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F3_S1_LBDAT_LB9001_F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F3_S1_LBDAT_LB9001_F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F4_S1_LBDAT_LB9001_F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F4_S1_LBDAT_LB9001_F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F4_S1_LBDAT_LB9001_F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLB9001_F4_S1_LBDAT_LB9001_F4_4.sql >> RWRBatch.log

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