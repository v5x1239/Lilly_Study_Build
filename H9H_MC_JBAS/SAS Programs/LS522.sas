/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS522.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Ensure progressive disease response is collected when Death from Study Disease occurs (in Summary or Survival Status) with no previously reported progression (OSD or obj PD).

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
/*LS522*/

data recist;
	set clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
	if IRRCRESP eq 'PD';
run;


data sum (KEEP = SUBJID DSDECOD DTHDAT);
	set clntrial.DS1001;
	if DSDECOD eq 'DEATH';
run;


data LS522a;
	merge recist (in=a) sum (in=b);
	by subjid;
	if a;
run;

data sur (KEEP = SUBJID SURVSTAT);
	set clntrial.DS1001;
	if SURVSTAT eq 'DEAD';
run;


data LS522b;
	merge recist (in=a) sur (in=b);
	by subjid;
	if a;
run;


data LS522;
	set LS522a LS522b;
run;


/*Print LS522*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure progressive disease response is collected when Death";
title2 "from Study Disease occurs (in Summary or Survival Status) with";
title3 "no previously reported progression (OSD or obj PD).";

  proc print data=LS522 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS522 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

