/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS016.sas
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
create table DS016 as 
select b.SITEMNEMONIC, a.SUBJID,a.BLOCKID, a.DSDECOD, a.DSTERM_4
from clntrial.ds1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) and upcase(DSCECOD) = 'LOST TO FOLLOW UP'
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;

/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS016*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition";
title2 "If status is Lost to follow-up, all free-text fields for that patient must contain no information";
  proc print data=DS016 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS016 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
