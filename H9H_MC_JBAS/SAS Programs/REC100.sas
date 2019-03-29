/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC100.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check the consistency of sex and birth years between GLS and the CRF. 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Check the consistency of sex and birth years between GLS and the CRF. 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : LABRSLTA 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
/*REC100*/

/*Add code here*/
proc sql;
create table REC100 as
select distinct a.MERGE_DATETIME, a.subjid, a.BRTHYR, b.BRTHDT, a.SEX, b.PATSEXCD
from clntrial.DM_DUMP a full join clntrial.LABRSLTA b 
on a.subjid=b.subjid
where datepart(MERGE_DATETIME) > input("&date",Date9.) and (a.SEX ne b.PATSEXCD or input(a.BRTHYR, best.) ne year(datepart(b.BRTHDT)));

quit;




/*Print REC100*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check the consistency of sex and birth";
title2 "years between GLS and the CRF";
  proc print data=REC100 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC100 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
