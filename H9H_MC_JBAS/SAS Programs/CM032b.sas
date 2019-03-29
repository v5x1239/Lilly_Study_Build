/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM032b.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If 'Medical History' is selected as Indication, ensure: 
					1. the MH ID entered matches a MH Number in Medical History CRF.  
					2. the start date of the medication must be >= the start date of the Medical History event or Pre-Existing Condition.  
					3. the start date of the medication must be <= the end date of the associated Medical History End date.
					4. the end date of the Treatment should be >= Medical History or Pre-Existing Condition Start Date. 
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
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.cmendat, a.CMINDC, a.CMMHNO, b.mhspid, b.mhterm,  b.MHSTDAT, b.mhendat
	from clntrial.cm1001 as a, clntrial.mh8001 as b
	where a.subjid=b.subjid and a.CMMHNO=b.mhspid;
	quit;

data CM032b;
	set cm032;
	if CMSTDAT ne . and MHSTDAT ne .  and CMSTDAT lt MHSTDAT then output;
	if CMSTDAT ne . and MHENDAT ne . and CMSTDAT gt MHENDAT then output;
	if cmendat ne . and MHSTDAT ne . and cmendat lt MHSTDAT then output;
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Medical History' is selected as Indication, ensure:";
 title2  "The MH ID entered matches a MH Number in Medical History CRF.";
title3 "the start date of the medication must be >= the start date";
title4 "of the Medical History event or Pre-Existing Condition.";
title5 "the start date of the medication must be <= the end date";
title6 "of the associated Medical History End date.";
title7 "the end date of the Treatment should be >= Medical History":
title8 "or Pre-Existing Condition Start Date.";
  proc print data=CM032b noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM032b nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
