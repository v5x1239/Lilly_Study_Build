/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX702.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Start date of the first dose (of each study treatment medication) must be within 28 days after Informed consent date
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I3O_MC_JSBF;*/

/*Prem, use the _all version of the raw dataset for programming*/


proc sql;
create table EX_SITE as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, /*a.VISIT,*/ a.EXTRT, a.EXSTDAT
/*	input(compress(catx(a.EXSTDATDD,a.EXSTDATMO,a.EXSTDATYY)),? date9.) */
/*	as EXSTDAT format=date9.*/
from clntrial.EX1001 a left join clntrial.DM1001c/*INF_SITE_ALL*/ b
/*on a.SUBJECT_ID=b.SUBJECT_ID*/
on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID
; 
create table DS_SITE as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, a.DSSTDAT
/*	input(compress(catx(a.DSSTDAT_ICDD,a.DSSTDAT_ICMO,a.DSSTDAT_ICYY)),? date9.) */
/*	as DSSTDAT format=date9.*/
from clntrial.DS2001 a left join clntrial.DM1001c/*INF_SITE_ALL*/ b
/*on a.SUBJECT_ID=b.SUBJECT_ID*/
on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID
;
quit;

data EX702 ;
	merge EX_SITE(in=a) DS_SITE(in=b);
	by SITEMNEMONIC SUBJID ;
	if a and b;
	if datdif(DSSTDAT,EXSTDAT,'act/act') > 28;
run;

/* visit variable not found */


/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print EX702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Start Date of Treatment";
title2 "Start date of the first dose (of each study treatment medication) must be within 28 days after Informed consent date";
  proc print data=EX702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
