/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PD05.sas
PROJECT NAME (required)           : I4T_JE_JVCW
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

data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;

Data irad;
set clntrial.IRAD3001;
stdat = datepart(IRADSTDAT);
endat = datepart(IRADENDAT);
format stdat endat date9.;
if page eq 'IRAD3001_LF1'; 
keep subjid RADOCCUR PRSPID IRADSTDAT IRADENDAT RADRSRGM;
run;
Proc sort;
by subjid;
run;

data sv;
set clntrial.SV1001;
dov = datepart(VISDAT);
format dov date9.;
if blockid eq '1';
label dov = 'VISDAT'; 
keep subjid blockid dov;
run;
Proc sort;
by subjid;
run;
data mer;
merge irad(in = a) sv dm;
by subjid;
run;
data PD05;
retain SITEMNEMONIC subjid blockid dov RADOCCUR PRSPID IRADSTDAT IRADENDAT RADRSRGM; 
set mer;
length flag $100.;
if dov ne . and stdat ne . then diff = dov - stdat;
if dov ne . and endat ne . then diff1 = dov - endat;
if (diff ne . and diff lt 14) and (diff1 ne . and diff1 lt 14) then flag = 'Radiation within 14 days prior to Randomization';
keep SITEMNEMONIC subjid blockid dov RADOCCUR PRSPID IRADSTDAT IRADENDAT RADRSRGM flag;
run;
Proc sort;
by subjid;
run;

/*Print PD05*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PR";
title2 "Have radiation therapy within 14 days prior to randomization.  Any lesion requiring palliative radiation or which has been previously irradiated cannot be considered for response assessment";
  proc print data=PD05 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set PD05 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
