/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH006.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : If identical term is entered in MH and AE forms, AE start date must be more than 1 day after MH stop date 
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
create table MH006_1 as
select coalesce(a.SUBJID, b.SUBJID) as SUBJID, 
	c.SITEMNEMONIC, a.AETERM, a.AEDECOD, b.AESTDAT
from clntrial.AE4001a a left join clntrial.AE4001b b
on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID
	left join clntrial.DM1001c c
		on a.SUBJID=c.SUBJID
order by c.SITEMNEMONIC, a.SUBJID, a.AEDECOD
; 

create table MH006_2 as 
select /*a.merge_datetime,*/ c.SITEMNEMONIC, a.SUBJID, a.MHSPID, a.MHTERM, 
	a.MHDECOD, a.MHSTDAT, a.MHENDAT
from clntrial.MH8001 a left join clntrial.DM1001c c
		on a.SUBJID=c.SUBJID
order by c.SITEMNEMONIC, a.SUBJID, a.MHDECOD
;
quit;

data MH006;
retain /*merge_datetime*/ SITEMNEMONIC SUBJID MHSPID MHTERM 
	MHDECOD MHSTDAT MHENDAT AETERM AEDECOD AESTDAT ;
merge MH006_1 MH006_2;
by SITEMNEMONIC SUBJID;
if MHDECOD=AEDECOD and datdif(MHSTDAT, AESTDAT, 'act/act') > 1;
/*if datepart(MERGE_DATETIME) > input("&date", ? Date9.);*/
keep /*merge_datetime*/ SITEMNEMONIC SUBJID MHSPID MHTERM 
	MHDECOD MHSTDAT MHENDAT AETERM AEDECOD AESTDAT ;
run;



/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print MH006*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Reported Event Term";
title2 "If identical term is entered in MH and AE forms, AE start date must be more than 1 day after MH stop date";
  proc print data=MH006 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH006 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
