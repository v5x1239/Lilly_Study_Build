/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM701.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001
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

proc sort data = clntrial.sv1001 out = dov;
	by subjid blockid;
run;

data dov1;
	set dov;
	by subjid blockid;
	if last.subjid;
run;

proc sql;
	create table CM701 as
	select a.subjid, a.cmtrt, a.CMSTDAT, a.CMENDAT, b.VISDAT
	from clntrial.cm1001 as a left join dov1 as b
	on a.subjid = b.subjid;
quit;

data CM701 (DROP = a1 b1);
	set cm701;
	a1=datepart(CMENDAT);
	b1=datepart(VISDAT);
	days=intck('day',a1,b1);
	if CMENDAT ne '';
run;





/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Review Treatment End date against last visit date.  It should not be extremely far out. 
	If it is extremely far out, query to make sure we are not missing a visit or if the med would 
	be better listed as ongoing as last visit was DDMMMYYYY.";
  proc print data=CM701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
