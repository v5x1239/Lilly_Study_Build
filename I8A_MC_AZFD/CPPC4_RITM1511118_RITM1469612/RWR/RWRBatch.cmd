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


@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_MH7001_LF1_igMH7001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_MH7001_LF1_igMH7001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_MH7001_LF1_igMH7001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_MH7001_LF1_igMH7001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE3001_LF1_igAE3001b_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE3001_LF1_igAE3001b_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE3001_LF1_igAE3001b_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_AE3001_LF1_igAE3001b_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CM1001_LF2_igCM1001_F2_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CM1001_LF2_igCM1001_F2_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CM1001_LF2_igCM1001_F2_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_CM1001_LF2_igCM1001_F2_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S9_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S7_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S7_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S7_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_SAE2001_LF1_igSAE2001_F1_S7_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_C1LF3_igEX1001_C1LF3_S1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_C1LF3_igEX1001_C1LF3_S1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_C1LF3_igEX1001_C1LF3_S1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateFormSection_EX1001_C1LF3_igEX1001_C1LF3_S1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_S1_VISDAT_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_S1_VISDAT_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_S1_VISDAT_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSV1001_S1_VISDAT_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F1_S1_DSSTDAT_IC_DS2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F1_S1_DSSTDAT_IC_DS2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F1_S1_DSSTDAT_IC_DS2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F1_S1_DSSTDAT_IC_DS2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F5_S1_DSSTDAT_IC_DS2001_F5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F5_S1_DSSTDAT_IC_DS2001_F5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F5_S1_DSSTDAT_IC_DS2001_F5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F5_S1_DSSTDAT_IC_DS2001_F5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSSTDAT_DS1F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F4_S1_DSDECOD_1_DS1F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igAPDM1001_APSC1_F1_S1_PREVAP_APDM_APSC_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igAPDM1001_APSC1_F1_S1_PREVAP_APDM_APSC_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igAPDM1001_APSC1_F1_S1_PREVAP_APDM_APSC_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igAPDM1001_APSC1_F1_S1_PREVAP_APDM_APSC_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_F4_S1_VSPERF_VS1F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_F4_S1_VSPERF_VS1F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_F4_S1_VSPERF_VS1F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_F4_S1_VSPERF_VS1F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_C1F4_S1_VSPERF_VS1C1F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_C1F4_S1_VSPERF_VS1C1F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_C1F4_S1_VSPERF_VS1C1F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVS1001_C1F4_S1_VSPERF_VS1C1F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSFUQ3001_F1_S1_SFUQEVTFLG_SFUQ3F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSFUQ3001_F1_S1_SFUQEVTFLG_SFUQ3F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSFUQ3001_F1_S1_SFUQEVTFLG_SFUQ3F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSFUQ3001_F1_S1_SFUQEVTFLG_SFUQ3F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F5_S1_DSSTDAT_DS1F5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F5_S1_DSSTDAT_DS1F5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F5_S1_DSSTDAT_DS1F5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F5_S1_DSSTDAT_DS1F5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSSTDAT_DS1F6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSSTDAT_DS1F6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSSTDAT_DS1F6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSSTDAT_DS1F6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSDECOD_DS1F6_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSDECOD_DS1F6_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSDECOD_DS1F6_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F6_S1_DSDECOD_DS1F6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_C1F6_S1_DSSTDAT_DS1C1F6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_C1F6_S1_DSDECOD_DS1C1F6_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSSTDAT_DS1F7_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSSTDAT_DS1F7_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSSTDAT_DS1F7_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSSTDAT_DS1F7_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSDECOD_DS1F7_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSDECOD_DS1F7_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSDECOD_DS1F7_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS1001_F7_S1_DSDECOD_DS1F7_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F1_S2_DADAT_DISPAMT_DA1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F1_S2_DADAT_DISPAMT_DA1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F1_S2_DADAT_DISPAMT_DA1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F1_S2_DADAT_DISPAMT_DA1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F2_S2_DADAT_RETAMT_DA1F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F2_S2_DADAT_RETAMT_DA1F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F2_S2_DADAT_RETAMT_DA1F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDA1001_F2_S2_DADAT_RETAMT_DA1F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXSTDAT_EX1F4_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXSTDAT_EX1F4_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXSTDAT_EX1F4_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F4_S1_EXSTDAT_EX1F4_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXENDAT_EX1F5_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXENDAT_EX1F5_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXENDAT_EX1F5_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEX1001_F5_S1_EXENDAT_EX1F5_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMOCCUR_CM3001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMOCCUR_CM3001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMOCCUR_CM3001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMOCCUR_CM3001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMONGO_CM3001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMONGO_CM3001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMONGO_CM3001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCM3001_F1_S1_CMONGO_CM3001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S2_PROCCUR_MRI_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S2_PROCCUR_MRI_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S2_PROCCUR_MRI_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S2_PROCCUR_MRI_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S3_PROCCUR_US_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S3_PROCCUR_US_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S3_PROCCUR_US_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S3_PROCCUR_US_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S4_PROCCUR_CT_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S4_PROCCUR_CT_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S4_PROCCUR_CT_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S4_PROCCUR_CT_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S5_PROCCUR_MRC_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S5_PROCCUR_MRC_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S5_PROCCUR_MRC_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S5_PROCCUR_MRC_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S6_PROCCUR_ERC_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S6_PROCCUR_ERC_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S6_PROCCUR_ERC_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S6_PROCCUR_ERC_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S7_PROCCUR_MRS_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S7_PROCCUR_MRS_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S7_PROCCUR_MRS_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S7_PROCCUR_MRS_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S8_PROCCUR_MRE_HMPR1F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S8_PROCCUR_MRE_HMPR1F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S8_PROCCUR_MRE_HMPR1F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHMPR1001_F1_S8_PROCCUR_MRE_HMPR1F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S1_HRFAASMDAT_HRFA1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S1_HRFAASMDAT_HRFA1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S1_HRFAASMDAT_HRFA1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S1_HRFAASMDAT_HRFA1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES7_HRFA1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES7_HRFA1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES7_HRFA1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES7_HRFA1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES9_HRFA1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES9_HRFA1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES9_HRFA1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES9_HRFA1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES11_HRFA1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES11_HRFA1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES11_HRFA1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igHRFA1001_F1_S4_HRFARES11_HRFA1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F1_S1_SUASMDAT_SU5001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F1_S1_SUASMDAT_SU5001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F1_S1_SUASMDAT_SU5001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F1_S1_SUASMDAT_SU5001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F2_S1_SUDOSADJ_RECDRUG_SU5F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F2_S1_SUDOSADJ_RECDRUG_SU5F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F2_S1_SUDOSADJ_RECDRUG_SU5F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU5001_F2_S1_SUDOSADJ_RECDRUG_SU5F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU1001_F3_S1_SUDOSADJ_ALCOHOL_SU1F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU1001_F3_S1_SUDOSADJ_ALCOHOL_SU1F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU1001_F3_S1_SUDOSADJ_ALCOHOL_SU1F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSU1001_F3_S1_SUDOSADJ_ALCOHOL_SU1F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLRSS1001_F1_S1_LRSSPERF_LRSS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLRSS1001_F1_S1_LRSSPERF_LRSS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLRSS1001_F1_S1_LRSSPERF_LRSS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLRSS1001_F1_S1_LRSSPERF_LRSS1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igBR1001_F1_S1_BRPERF_BR1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igBR1001_F1_S1_BRPERF_BR1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igBR1001_F1_S1_BRPERF_BR1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igBR1001_F1_S1_BRPERF_BR1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEASMDAT_SAE2F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEAWADAT_SAE2F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEAWADAT_SAE2F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEAWADAT_SAE2F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSAE2001_F1_S1_SAEAWADAT_SAE2F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F3_S1_DSSTDAT_IC_DS2001_F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F3_S1_DSSTDAT_IC_DS2001_F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F3_S1_DSSTDAT_IC_DS2001_F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_F3_S1_DSSTDAT_IC_DS2001_F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C2F3_S1_DSSTDAT_IC_DS2001_C2F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C2F3_S1_DSSTDAT_IC_DS2001_C2F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C2F3_S1_DSSTDAT_IC_DS2001_C2F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C2F3_S1_DSSTDAT_IC_DS2001_C2F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C1F3_S1_DSSTDAT_IC_DS2001_C1F3_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C1F3_S1_DSSTDAT_IC_DS2001_C1F3_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C1F3_S1_DSSTDAT_IC_DS2001_C1F3_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igDS2001_C1F3_S1_DSSTDAT_IC_DS2001_C1F3_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCDR2001_F1_CDRASMDAT_CDR2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCDR2001_F1_CDRASMDAT_CDR2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCDR2001_F1_CDRASMDAT_CDR2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCDR2001_F1_CDRASMDAT_CDR2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFAQ2001_F1_S1_FAQASMDAT_FAQ2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFAQ2001_F1_S1_FAQASMDAT_FAQ2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFAQ2001_F1_S1_FAQASMDAT_FAQ2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFAQ2001_F1_S1_FAQASMDAT_FAQ2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMMSE12001_F1_S1_MMSE1ASMDAT_MMSE12001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMMSE12001_F1_S1_MMSE1ASMDAT_MMSE12001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMMSE12001_F1_S1_MMSE1ASMDAT_MMSE12001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igMMSE12001_F1_S1_MMSE1ASMDAT_MMSE12001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igNPI2001_F1_S1_NPIDAT_NPI2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igNPI2001_F1_S1_NPIDAT_NPI2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igNPI2001_F1_S1_NPIDAT_NPI2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igNPI2001_F1_S1_NPIDAT_NPI2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRBANS1001_F1_S1_RBANSASMDAT_RBANS1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRBANS1001_F1_S1_RBANSASMDAT_RBANS1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRBANS1001_F1_S1_RBANSASMDAT_RBANS1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRBANS1001_F1_S1_RBANSASMDAT_RBANS1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRUDF1001_F1_S4_RUDFPRES5_RUDF1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRUDF1001_F1_S4_RUDFPRES5_RUDF1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRUDF1001_F1_S4_RUDFPRES5_RUDF1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igRUDF1001_F1_S4_RUDFPRES5_RUDF1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADL2001_F1_S1_ADLASMDAT_ADL2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADL2001_F1_S1_ADLASMDAT_ADL2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADL2001_F1_S1_ADLASMDAT_ADL2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADL2001_F1_S1_ADLASMDAT_ADL2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSKE2001_F1_S1_SKEASMDAT_SKE2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSKE2001_F1_S1_SKEASMDAT_SKE2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSKE2001_F1_S1_SKEASMDAT_SKE2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSKE2001_F1_S1_SKEASMDAT_SKE2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFUN2001_F2_S1_FUNASMDAT_FUN2001_F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFUN2001_F2_S1_FUNASMDAT_FUN2001_F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFUN2001_F2_S1_FUNASMDAT_FUN2001_F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igFUN2001_F2_S1_FUNASMDAT_FUN2001_F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVACE2001_F1_S1_VACEPERF_VACE2F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVACE2001_F1_S1_VACEPERF_VACE2F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVACE2001_F1_S1_VACEPERF_VACE2F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igVACE2001_F1_S1_VACEPERF_VACE2F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igIOP2001_F1_S1_IOPASMDAT_IOP2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igIOP2001_F1_S1_IOPASMDAT_IOP2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igIOP2001_F1_S1_IOPASMDAT_IOP2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igIOP2001_F1_S1_IOPASMDAT_IOP2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSL2001_F1_S1_SLPERF_SL2001_F2_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSL2001_F1_S1_SLPERF_SL2001_F2_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSL2001_F1_S1_SLPERF_SL2001_F2_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igSL2001_F1_S1_SLPERF_SL2001_F2_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEQ5D5L2001_F1_EQ5D5LASMDAT_EQ5DL2_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEQ5D5L2001_F1_EQ5D5LASMDAT_EQ5DL2_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEQ5D5L2001_F1_EQ5D5LASMDAT_EQ5DL2_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igEQ5D5L2001_F1_EQ5D5LASMDAT_EQ5DL2_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADASS3001_F1_S1_ADASSASMDAT_ADASS3_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADASS3001_F1_S1_ADASSASMDAT_ADASS3_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADASS3001_F1_S1_ADASSASMDAT_ADASS3_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igADASS3001_F1_S1_ADASSASMDAT_ADASS3_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCSS2001_F1_S4_CSS0222_CMPD_CSS2001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCSS2001_F1_S4_CSS0222_CMPD_CSS2001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCSS2001_F1_S4_CSS0222_CMPD_CSS2001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCSS2001_F1_S4_CSS0222_CMPD_CSS2001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igWAISDS1001_F1_S1_WASIDSASMDAT_WAISDS1_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igWAISDS1001_F1_S1_WASIDSASMDAT_WAISDS1_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igWAISDS1001_F1_S1_WASIDSASMDAT_WAISDS1_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igWAISDS1001_F1_S1_WASIDSASMDAT_WAISDS1_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCFT1001_F1_S1_CFTASMDAT_CFT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCFT1001_F1_S1_CFTASMDAT_CFT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCFT1001_F1_S1_CFTASMDAT_CFT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igCFT1001_F1_S1_CFTASMDAT_CFT1001_F1_4.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLFT1001_F1_S1_LFTASMDAT_LFT1001_F1_1.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLFT1001_F1_S1_LFTASMDAT_LFT1001_F1_2.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLFT1001_F1_S1_LFTASMDAT_LFT1001_F1_3.sql >> RWRBatch.log
@SQLPLUS  -s -l %uid%/%pid%@%dbinstance% @updateSectionItem_igLFT1001_F1_S1_LFTASMDAT_LFT1001_F1_4.sql >> RWRBatch.log

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