/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM013.sas
PROJECT NAME (required)           : I5Q_MC_CGAR
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
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
create table CM as 
select a.merge_datetime, b.SITEMNEMONIC, a.SUBJID, a.CMSPID ,a.CMTRT, a.CMSTDAT
from clntrial.CM1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;
proc sql;
create table ds as 
select b.SITEMNEMONIC, a.SUBJID, a.DSCAT, a.DSSCAT
from clntrial.ds1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;
proc sql;
create table sv as 
select b.SITEMNEMONIC, a.SUBJID, a.VISDAT
from clntrial.sv1001 a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID
; 
quit;
data cm16;
merge cm ds sv;
by subjid;
run;
proc sql;
create table CM013 as 
select * from CM16
where datepart(MERGE_DATETIME) > input("&date", ? Date9.) and upcase(DSSCAT)='STUDY DISPOSITION'
order by SITEMNEMONIC, SUBJID
;
quit;

/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print CM013*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Concomitant Therapy";
title2 "Treatment Start Date must be <= the date subject discontinued study";
  proc print data=CM013 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM013 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
