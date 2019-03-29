/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX083.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
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
create table site as 
select /*a.merge_datetime,*/ SITEMNEMONIC, SUBJID
from clntrial.DM1001c 
order by SUBJID
; 
quit;
data ex;
set clntrial.ex1001;
if EXPTRTDATDD ne '' and length(EXPTRTDATDD) eq 1 then dd=compress('0'||EXPTRTDATDD);
if EXPTRTDATMO ne '' and length(EXPTRTDATMO) eq 1 then mm=compress('0'||EXPTRTDATMO);
if EXPTRTDATDD ne '' and length(EXPTRTDATDD) eq 2 then dd=compress(EXPTRTDATDD);
if EXPTRTDATMO ne '' and length(EXPTRTDATMO) eq 2 then mm=compress(EXPTRTDATMO);
if DD ne '' and MM ne '' and EXPTRTDATYY ne '' then
date1 = Compress(DD)||'\'||compress(MM)||'\'||compress(EXPTRTDATYY);
if date1 ne '' then EXPTRTDAT = input(date1,ddmmyy10.);
format EXPTRTDAT date9.;
keep SUBJID BLOCKID page EXTRT EXPTRTDATDD EXPTRTDATMO EXPTRTDATYY EXPTRTDAT date1 EXSTDAT;
run;
proc sort;
by SUBJID;
run;
data all;
merge ex(in = a) site;
by subjid;
if a;
run;
data fin;
set all;
if EXPTRTDAT ne . and EXSTDAT ne . and EXPTRTDAT > EXSTDAT;
run;
proc sql;
create table EX083 as 
select /*merge_datetime,*/ SITEMNEMONIC, SUBJID, BLOCKID, EXTRT, EXPTRTDAT,EXSTDAT
from fin
order by SITEMNEMONIC, SUBJID
;
quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print EX083*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "EX (Exposure)";
title2 "Planned Treatment Start Date must be less than or equal to Treatment start date.";
  proc print data=EX083 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX083 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
