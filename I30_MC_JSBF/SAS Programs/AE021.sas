/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE021.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : If identical term is recorded on AE and MH CRFs, start dates must not match
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
create table AE021_a as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, a.AEGRPID, a.AETERM, a.AEDECOD, 
	c.AESTDAT
from clntrial.AE4001a a left join clntrial.DM1001c/*INF_SITE_ALL*/ b
	on a.SUBJID=b.SUBJID
	left join clntrial.AE4001b c
		on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID
; 

create table AE021_b as 
select /*a.merge_datetime,*/b.SITEMNEMONIC,a.SUBJID,a.MHSPID,a.MHTERM,a.MHDECOD,
	a.DICT_DICTVER, a.MHSTDAT 
from clntrial.MH8001 a left join clntrial.DM1001c/*INF_SITE_ALL*/ b
on a.SUBJID=b.SUBJID
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID
;
quit;

data AE021 ;
	merge AE021_b (in=a) AE021_a (in=b);
	by SITEMNEMONIC SUBJID;
	if a and b;
/*	if datepart(MERGE_DATETIME) > input("&date",Date9.);*/
	if strip(upcase(AEDECOD)) = strip(upcase(MHDECOD)) ;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print AE021*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Start Date of Adverse Event";
title2 "If identical term is recorded on AE and MH CRFs, start dates must not match";
  proc print data=AE021 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE021 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
