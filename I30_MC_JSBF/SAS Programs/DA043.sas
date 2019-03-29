/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DA043.sas
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
data da1;
set clntrial.DA1001;
if page eq 'DA1001_LF1';
if DADAT_DISPAMTDD ne '' and length(DADAT_DISPAMTDD) eq 1 then dd=compress('0'||DADAT_DISPAMTDD);
if DADAT_DISPAMTMO ne '' and length(DADAT_DISPAMTMO) eq 1 then mm=compress('0'||DADAT_DISPAMTMO);
if DADAT_DISPAMTDD ne '' and length(DADAT_DISPAMTDD) eq 2 then dd=compress(DADAT_DISPAMTDD);
if DADAT_DISPAMTMO ne '' and length(DADAT_DISPAMTMO) eq 2 then mm=compress(DADAT_DISPAMTMO);
if DD ne '' and MM ne '' and DADAT_DISPAMTYY ne '' then
date1 = Compress(DD)||'\'||compress(MM)||'\'||compress(DADAT_DISPAMTYY);
if date1 ne '' then DADAT_DISPAMT = input(date1,ddmmyy10.);
format DADAT_DISPAMT date9.;
keep SUBJID BLOCKID page DASPID DADAT_DISPAMTDD DADAT_DISPAMTMO DADAT_DISPAMTYY DADAT_DISPAMT date1;
run;
proc sort;
by SUBJID BLOCKID DASPID;
run;
data da2;
set clntrial.DA1001;
if page eq 'DA1001_LF2';
page1 = page;
if DADAT_RETAMTDD ne '' and length(DADAT_RETAMTDD) eq 1 then dd=compress('0'||DADAT_RETAMTDD);
if DADAT_RETAMTMO ne '' and length(DADAT_RETAMTMO) eq 1 then mm=compress('0'||DADAT_RETAMTMO);
if DADAT_RETAMTDD ne '' and length(DADAT_RETAMTDD) eq 2 then dd=compress(DADAT_RETAMTDD);
if DADAT_RETAMTMO ne '' and length(DADAT_RETAMTMO) eq 2 then mm=compress(DADAT_RETAMTMO);
if DD ne '' and MM ne '' and DADAT_RETAMTYY ne '' then
date1 = Compress(DD)||'\'||compress(MM)||'\'||compress(DADAT_RETAMTYY);
if date1 ne '' then DADAT_RETAMT = input(date1,ddmmyy10.);
format DADAT_RETAMT date9.;
keep SUBJID BLOCKID DASPID page1 DADAT_RETAMTDD DADAT_RETAMTMO DADAT_RETAMTYY DADAT_RETAMT date1;
run;
proc sort;
by SUBJID BLOCKID DASPID;
run;
data da;
merge da1 da2;
by SUBJID BLOCKID DASPID;
run;
data all;
merge da(in = a) site;
by subjid;
run;
data fin;
set all;
if DADAT_DISPAMT ne . and DADAT_RETAMT ne . and DADAT_DISPAMT >= DADAT_RETAMT;
run;
proc sql;
create table DA043 as 
select /*merge_datetime,*/ SITEMNEMONIC, SUBJID, BLOCKID, DASPID, DADAT_DISPAMT,DADAT_RETAMT 
from fin
order by SITEMNEMONIC, SUBJID
;
quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DA043*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "DA_DISPENSE (Drug Accountability: Dispensed)";
title2 "Returned date must be greater than dispensed date in same visit.";
  proc print data=DA043 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DA043 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
