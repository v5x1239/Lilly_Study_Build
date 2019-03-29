/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS518.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If objective PD then PD date must match Lesion assessment date where Progressive disease was first documented and RESP must be PD in the visit where PD was documented.

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
/*LS518*/


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

data LS518a;
	set target1a target1 target2 target3 Ntarget1 ntarget2;
run;


proc sort data=LS518a;
	by subjid;
run;

data recist;
	set clntrial.RS1001 (DROP=RSDATDD RSDATMO RSDATYY) clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
run;


proc sort data=recist;
	by subjid;
run;

data LS518;
	merge LS518a (in=a) recist (in=b);
	by subjid;
	if a;
	if OVRLRESP eq 'PD' or IRRCRESP eq 'PD';
run;

/*Print LS518*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If objective PD then PD date must match Lesion assessment";
title2 "date where Progressive disease was first documented and RESP";
title3 "must be PD in the visit where PD was documented.";

  proc print data=LS518 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS518 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
