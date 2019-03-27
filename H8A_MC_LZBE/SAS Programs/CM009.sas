/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SAE702.sas
PROJECT NAME (required)           : H8A_MC_LZBE
DESCRIPTION (required)            : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required � study specific data verification report
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

libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=H8A_MC_LZBE;

/*Prem, use the _all version of the raw dataset for programming*/


proc sql;
create table SAE702_ as 
select a.merge_datetime, b.SITEMNEMONIC, a.SUBJID,
from clntrial.CM1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID
; 

create table SAE702 as 
select a.* /*, b.AEDECOD as b_AEDECOD, b.AEGRPID as b_AEGRPID*/
from SAE702_ a, SAE702_ b
where a.SITEMNEMONIC=b.SITEMNEMONIC and 
	a.SUBJID=b.SUBJID and 
	a.AEDECOD=b.AEDECOD and 
	a.AEGRPID~=a.AEGRPID
order by a.SITEMNEMONIC, a.SUBJID
;
quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print SAE702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Dictionary-Derived Term";
title2 "Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study";
  proc print data=SAE702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SAE702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
