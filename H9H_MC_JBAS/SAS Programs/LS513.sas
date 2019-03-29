/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS513.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Look for missing lesion data for patients who have not died/LTF and don't have objective PD reported yet and haven't had a scan within 60 days (frequency based on trial specifications) since their last scan.

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
/*LS513*/


proc sql;
	
	create table target1a as 
	select a.*, b.TRSPID, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.SAXIS, b.SAXISU, b.TUMSTNW, b.TRLNKID
	from clntrial.TU1001A as a left join clntrial.TU1001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 

	create table target3 as 
	select a.*, b.TRSPID, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.LPERPDIA, b.LPERPDAU, b.TUMSTNW, b.TRLNKID
	from clntrial.TU4001A as a left join clntrial.TU4001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 


	create table target1 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTATT, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.SAXIS, b.SAXISU, b.TRLNKID
	from clntrial.TU2001A as a left join clntrial.TU2001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 

	
	create table target2 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTATT, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.LPERPDIA, b.LPERPDAU, b.TRLNKID
	from clntrial.TU5001A as a, clntrial.TU5001B as b
	where a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT;



	create table Ntarget1 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTATN, b.TRLNKID
	from clntrial.TU3001A as a, clntrial.TU3001B as b
	where a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT;

	create table Ntarget2 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTTNC, b.TRLNKID
	from clntrial.TU6001A as a, clntrial.TU6001B as b
	where a.subjid=b.subjid and a.page=b.page and a.PAGERPT=b.PAGERPT;
quit;

data LS513a;
	set target1a target1 target2 target3 Ntarget1 ntarget2;
run;


proc sort data=LS513a;
	by subjid;
run;

data recist;
	set clntrial.RS1001 (DROP=RSDATDD RSDATMO RSDATYY) clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
run;


proc sort data=recist;
	by subjid;
run;

data LS513;
	merge LS513a (in=a) recist (in=b);
	by subjid;
	if a;
run;

/*Print LS513*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Look for missing lesion data for patients who have not died/LTF";
title2 "and don't have objective PD reported yet and haven't had a scan "; 
title3 "within 60 days (frequency based on trial specifications) since their last scan.";

  proc print data=LS513 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS513 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
