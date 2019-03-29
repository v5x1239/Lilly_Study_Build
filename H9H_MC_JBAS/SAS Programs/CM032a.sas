/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM032a.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If a MH event is selected as Indication, then the MH ID entered must have a matching MH Number in MH CRF.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : mh8001_f1
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
proc sql;
	create table CM032 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMINDC, a.CMMHNO, b.mhspid, b.mhterm,  b.MHSTDAT
	from clntrial.cm1001 as a, clntrial.mh8001 as b
	where a.subjid=b.subjid;
	quit;

data CM032b cm032c;
	set cm032;
	if CMMHNO=mhspid then output cm032b;
	if CMMHNO ne mhspid then output cm032c;
run;

proc sort data=CM032b;
	by subjid;
run;

proc sort data=CM032c;
	by subjid;
run;

data CM032a;
	merge CM032c (in=a) CM032b (in=b);
	by subjid;
	if a and not b;
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If a MH event is selected as Indication, then the MH ID";
 title2  "entered must have a matching MH Number in MH CRF.";
  proc print data=CM032a noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM032a nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
