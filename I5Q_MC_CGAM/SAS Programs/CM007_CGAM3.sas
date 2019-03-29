/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM007.sas
PROJECT NAME (required)           : I5Q-MC-CGAM
DESCRIPTION (required)            : If any excluded medications, as defined in protocol, are reported as part of the subject's Therapy (includes concomitant and prior therapy), notify the study team and they must be documented as Protocol Deviations.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM
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

/*Add code here*/

proc sql;
	create table CM007 as
		select merge_datetime,SUBJID, CMSPID,  CMTRT, CMSTDAT, CMONGO, CMENDAT, CMINDC, CMAEGRPID4,CMMHNO4, CMDOSE, CMDOSEU, CMDOSFRQ, CMROUTE, CMDECOD, CMTRADNM, CMCLAS, CMCLASCD
			from clntrial.CM1001_d
				where datepart(MERGE_DATETIME) > input("&date",Date9.) and CMDECOD in ('GABAPENTIN', 'TOPIRAMATE', 'VALPROATE', 'VERAPMIL');
quit;


/*Print CM007*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If any excluded medications, as defined in protocol,";
title2 "are reported as part of the subject's Therapy (includes";
title3 "concomitant and prior therapy), notify the study team and";
title4 "they must be documented as Protocol Deviations.";
  proc print data=CM007 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM007 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
