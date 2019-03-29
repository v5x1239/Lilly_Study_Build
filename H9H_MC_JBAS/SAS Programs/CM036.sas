/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM036.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required � study specific data verification report
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
	create table CM036 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMENDAT, a.CMINDC, a.CMMHNO, b.mhspid, b.mhterm,  b.MHSTDAT, b.MHENDAT
	from clntrial.cm1001 as a, clntrial.mh8001 as b
	where a.subjid=b.subjid and a.CMMHNO = b.mhspid and CMINDC = 'MEDICAL HISTORY EVENT' and CMENDAT gt (30+b.MHENDAT);
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Medical History' is selected as Indication, and the MH ID entered matches a MH Number in Medical History CRF, then the end date of the Treatment must be <= 30 days after Medical History End Date.";
  proc print data=CM036 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM036 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
