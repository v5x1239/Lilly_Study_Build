/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE038.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : SAE reconciliation with Pharmacovigilance Database If 'Is the event serious' is 'Yes' and 'Death' is selected, the event end date must be the same as the date of death in Pharmacovigilance Database
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
create table AE038 as
select /*a.merge_datetime,*/ c.SITEMNEMONIC, a.SUBJID, a.AEGRPID, a.AETERM, 
	a.AEDECOD, b.AESTDAT, b.AESER, b.AESDTH, b.AEENDAT
from clntrial.AE4001a a left join clntrial.AE4001b b
on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID
	left join clntrial.DM1001c c
		on a.SUBJID=c.SUBJID
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.) */
group by c.SITEMNEMONIC, a.SUBJID, a.AETERM
having (count(a.AETERM)>1 and strip(upcase(b.AESER))='YES')
; 
quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print AE038*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Results in Death";
  title2 "SAE reconciliation with Pharmacovigilance Database If 'Is the event serious' is 'Yes' and 'Death' is selected, the event end date must be the same as the date of death in Pharmacovigilance Database";
  proc print data=AE038 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE038 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
