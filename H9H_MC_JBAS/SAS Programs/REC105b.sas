/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC105b.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for GLS ECG records without corresponding date of visit panel for the same project investigator patient visit (PIPV).
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Check for GLS ECG records without corresponding date of visit panel for the same project investigator patient visit (PIPV). 
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
/*REC105b*/

/*Add code here*/
proc sql;
create table REC105b as
select distinct a.MERGE_DATETIME, a.subjid, b.VISID, b.CLLCTDT, a.BLOCKID, a.VISDAT
from clntrial.sv_DUMP a full join clntrial.LABRSLTA b 
on a.subjid=b.subjid and b.VISID=input(a.BLOCKID, best.)
where datepart(MERGE_DATETIME) > input("&date",Date9.) and RQSTNTYP ="ECG" and datepart (CLLCTDT) <> datepart(VISDAT);
quit;




/*Print REC105b*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for GLS ECG records without corresponding";
title2 "date of visit panel for the same project investigator";
 title3 "patient visit (PIPV).";
  proc print data=REC105b noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC105b nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
