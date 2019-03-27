/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE040.sas
PROJECT NAME (required)           : I5Q_MC_CGAR
DESCRIPTION (required)            : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I5Q_MC_CGAR;*/

/*Prem, use the _all version of the raw dataset for programming*/


proc sql;
create table AE040 as 
select a.MERGE_DATETIME,b.SITEMNEMONIC,a.subjid,a.AEGRPID,a.AETERM,a.AEDECOD,c.AEREL
from clntrial.AE3001a a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
	left join clntrial.AE3001b c
	on a.SUBJID=c.SUBJID
	where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.) and c.AEREL eq 'Y'
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;

/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print AE040*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Adverse Event";
title2 "If Related to Study Treatment 'Yes', the event term must be a logical condition";
  proc print data=AE040 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE040 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
