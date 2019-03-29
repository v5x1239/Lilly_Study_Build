/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST023.sas
PROJECT NAME (required)           : I9A_MC_JLDA
DESCRIPTION (required)            : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Prem, use the below libame statment to call in the Clintrial raw datasets.*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I9A_MC_JLDA;*/

/*Prem, use the _all version of the raw dataset for programming*/


proc sql;
create table dm as 
select SUBJID,SITEMNEMONIC
from clntrial.DM1001c 
order by SUBJID
; 
quit;
data syst1;
set clntrial.SYST3001;
if SYSTSTDAT ne . then
SYSTSTDAT1 = datepart(SYSTSTDAT);
if SYSTENDAT ne . then
SYSTENDAT1 = datepart(SYSTENDAT);
format SYSTSTDAT1 SYSTENDAT1 date9.;
keep subjid blockid page SYSTOCCUR SYSTGRPID CMSPID SYSTTRT SYSTSTDAT1 SYSTONGO
SYSTENDAT1 SYSTCAT CMDECOD CMTRADNM TRTTERMCD CMCLASCD CMCLAS SYSTMDLY DICT_DICTVER CMINDC;
run;
data syst;
set syst1;
SYSTSTDAT = SYSTSTDAT1;
SYSTENDAT = SYSTENDAT1;
format SYSTSTDAT SYSTENDAT date9.;
run;
proc sort;
by subjid SYSTGRPID;
run;
data sv;
set clntrial.SV1001;
V1DOV = datepart(VISDAT);
format V1DOV date9.;
if page eq 'SV1001_LF1' and BLOCKID eq '1';
keep subjid V1DOV;
run;
proc sort;
by subjid;
run;
data fin;
	merge dm syst(in = a) sv;
	by subjid;
	if a;
run;
data SYST023;
	retain SITEMNEMONIC subjid blockid page SYSTOCCUR SYSTGRPID CMSPID SYSTTRT SYSTSTDAT SYSTONGO
	SYSTENDAT SYSTCAT CMDECOD CMTRADNM TRTTERMCD CMCLASCD CMCLAS SYSTMDLY DICT_DICTVER CMINDC VISDAT;
	set fin;
	if SYSTENDAT ne . and V1DOV ne . then diff = V1DOV - SYSTENDAT;
	if diff ne . and diff lt 14;
	keep SITEMNEMONIC subjid blockid page SYSTOCCUR SYSTGRPID CMSPID SYSTTRT SYSTSTDAT SYSTONGO
	SYSTENDAT SYSTCAT CMDECOD CMTRADNM TRTTERMCD CMCLASCD CMCLAS SYSTMDLY DICT_DICTVER CMINDC VISDAT;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print SYST023*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Systemic and Locoregional Therapies";
title2 "Treatment End Date must be at least 14 days prior to cycle 1 date";
  proc print data=SYST023 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SYST023 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
