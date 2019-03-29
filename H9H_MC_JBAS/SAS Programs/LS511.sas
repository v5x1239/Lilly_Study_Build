/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS511.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for new lesions added after baseline.  If new lesion(s) present, cycle assessment response should be PD for lesions assessed by RECIST1.1 and mRECIST.  PD is correct for irRECIST only if new lesion added to sum indicates PD.

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
/*LS511*/


proc sql;
	
	create table target1a as 
	select a.*, b.TRSPID, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.SAXIS, b.SAXISU, b.TUMSTNW, b.TRLNKID
	from clntrial.TU1001A as a left join clntrial.TU1001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 

	create table target3 as 
	select a.*, b.TRSPID, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.LPERPDIA, b.LPERPDAU, b.TUMSTNW, b.TRLNKID
	from clntrial.TU4001A as a left join clntrial.TU4001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 

quit;

data LS511a;
	set target1a target3;
run;

proc sort data=LS511a;
	by subjid;
run;

data recist;
	set clntrial.RS1001 (DROP=RSDATDD RSDATMO RSDATYY) clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
run;


proc sort data=recist;
	by subjid;
run;

data LS511;
	merge LS511a (in=a) recist (in=b);
	by subjid;
	if a;
run;



/*Print LS511*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for new lesions added after baseline.  If new lesion(s) present,";
title2 "cycle assessment response should be PD for lesions assessed by RECIST1.1";
title3 "and mRECIST. PD is correct for irRECIST only if new lesion added to sum indicates PD.";

  proc print data=LS511 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS511 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
