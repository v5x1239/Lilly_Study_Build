/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS519.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Verify that all PD's occurring before 801 have summary reason as PD or death.

SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : TU2001, TU5001,TU3001, TU6001      
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
/*LS519*/

data recist;
	set clntrial.RS1001 (DROP=RSDATDD RSDATMO RSDATYY) clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
	if OVRLRESP eq 'PD' or IRRCRESP eq 'PD';
run;


proc sort data=recist;
	by subjid;
run;

data sum;
	set clntrial.DS1001;
	if DSDECOD ne 'PROGRESSIVE DISEASE' or DSDECOD ne 'DEATH';
run;


data LS519;
	merge recist (in=a) sum (in=b);
	by subjid;
	if a;
run;



/*Print LS519*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Verify that all PD's occurring before 801 ";
title2 "have summary reason as PD or death.";

  proc print data=LS519 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS519 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
