/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM031.sas
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
create table CM031 as 
select a.MERGE_DATETIME,b.SITEMNEMONIC,a.subjid,a.CMSPID,a.CMTRT,a.CMSTDAT,a.CMONGO,a.CMMENDAT,a.CMINDC,a.CMAEGRPID4,a.CMDECOD, a.CMCLAS,a.CMCLASCD
from clntrial.CM1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
	where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.) and a.CMINDC eq 'ADVERSE EVENT'
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;

/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print CM031*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Concomitant Therapy";
title2 "If 'Adverse Event' is selected as Indication, the medication must be appropriate to treat the event assigned.";
  proc print data=CM031 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM031 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
