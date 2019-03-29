/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS516.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : RECIST 1.1: Ensure only a maximum of 2 lesions are reported per organ on the baseline Target lesion page/panel.  Maximum of 5 lesions. 

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
/*LS516*/


proc sql;
	create table target1 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTATT, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.SAXIS, b.SAXISU, b.TRLNKID
	from clntrial.TU2001A as a left join clntrial.TU2001B as b
	on a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT; 

	
	create table target2 as 
	select a.*, b.TRSPID, b.TRSTDAT, b.TRMETHOD, b.TRMTHODO, b.TRPERF, b.TUMSTATT, b.TRSTRESC, b.LDIAM, b.LDIAMU, b.LPERPDIA, b.LPERPDAU, b.TRLNKID
	from clntrial.TU5001A as a, clntrial.TU5001B as b
	where a.subjid=b.subjid and a.page=b.page and a.PAGERPT= b.PAGERPT;
quit;


proc sql;
	create table LS516a as 
	select *, count(*) as Count
	from target1
	group by subjid, TULOC, TRSPID
	having count(*) > 2;

	create table LS516b as 
	select *, count(*) as Count
	from target2
	group by subjid, TULOC, TRSPID
	having count(*) > 2;

data LS516;
	set LS516a LS516b;
run;



/*Print LS516*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "RECIST 1.1: Ensure only a maximum of 2 lesions are reported per organ ";
title2 "on the baseline Target lesion page/panel.  Maximum of 5 lesions. ";
  proc print data=LS516 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS516 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
