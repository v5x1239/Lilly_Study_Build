/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE027.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

proc sql;
create table aefin as select MERGE_DATETIME,SITEMNEMONIC,SUBJID,AEGRPID,AETERM,AEDECOD,AESPID,AESTDAT,AEONGO,AEENDAT,
 AESEV,AESER,AESDTH,AESLIFE,AESHOSP,AESDISAB,AESCONG,AESMIE,AEREL,AERELDVC,flag,count(subjid) as sub
from clntrial.AE027_H
group by SUBJID,AEGRPID
having sub gt 1
order by SUBJID,AEGRPID;
quit;
proc sql;
create table AE027 as select MERGE_DATETIME,SITEMNEMONIC,SUBJID,AEGRPID,AETERM,AEDECOD,AESPID,AESTDAT,AEONGO,AEENDAT,
 AESEV,AESER,AESDTH,AESLIFE,AESHOSP,AESDISAB,AESCONG,AESMIE,AEREL,AERELDVC,flag
from aefin
order by SUBJID,AEGRPID;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "Events within the same AEGRPID must have a change in Severity or in Seriousnessin consecutive chronologic entries.";

proc print data=AE027 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE027 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

