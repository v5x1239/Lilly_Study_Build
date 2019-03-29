/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM022.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If Medication/Therapy is Ongoing ('YES') and the Indication reported is 'Medical History Event', the End Date of the Medical History Event (MHID) on the MH form must also be 'Ongoing'. 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001_f1
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

data cm;
	set clntrial.cm1001;
	if CMONGO = 'Y' and CMINDC = 'MEDICAL HISTORY EVENT';
run;

proc sql;
	create table CM022 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMENDAT, a.cmongo, a.CMINDC, a.CMMHNO, b.mhspid, b.mhterm,  b.mhSTDAT, b.mhENDAT, b.mhONGO
	from cm as a, clntrial.mh8001 as b
	where a.subjid=b.subjid and a.CMMHNO= b.mhspid;
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Medication/Therapy is Ongoing ('YES') and the Indication reported is 'Medical History Event', the End Date of the Medical History Event (MHID) on the MH form must also be 'Ongoing'.";
  proc print data=CM022 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM022 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
