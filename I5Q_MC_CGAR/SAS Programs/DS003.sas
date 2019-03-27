/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
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

proc sql;
create table DS as 
select /*MERGE_DATETIME,*/SUBJID,count(subjid) as cnt,BLOCKID,DSDECOD,DSCAT_1,DSSCAT
from clntrial.DS1_DUMP
where upcase(DSSCAT) = 'STUDY DISPOSITION' 
group by SUBJID,DSSCAT
order by SUBJID,DSSCAT
; 
quit;
data ds1;
set ds;
if cnt gt 1;
run;
proc sql;
create table DS003 as 
select /*a.MERGE_DATETIME,*/a.BLOCKID,a.DSDECOD,a.DSCAT_1,a.DSSCAT
from ds1 a 
	/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order a.SUBJID
; 
quit;

/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS003*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition";
title2 "One summary date/record must exist for every patient";
  proc print data=DS003 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS003 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
