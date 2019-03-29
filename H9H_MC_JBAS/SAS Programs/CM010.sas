/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM010.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for duplicate and overlapping medications between Concomitant Therapy and Previous Therapy panels. If the same Therapy is recorded in Prior Therapy CRF (E.g.- CM2001), Prior Therapy's End Date must be < CM Start Date.
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
/*CM010*/

/*Add code here*/

proc sort data = clntrial.cm1001 (KEEP = SUBJID CMSPID CMTRT CMDECOD CMSTDAT CMENDAT CMONGO) out = cm1001;
	by subjid cmdecod;
run;
 
data prev;
	set clntrial.SG1001 (KEEP = SUBJID SGSPID SGPROC SGPROCO SGDAT) 
	    clntrial.IRAD2001 (KEEP = SUBJID IRADSPID IRADSTD IRADEND)  
	    clntrial.PR1001 (KEEP = SUBJID PRSPID PRTRT PRSTD PREND);
	    IRTERM = "RADIOTHERAPY";
	    if SGPROC ne '' then cmdecod = SGPROC;
	    if IRTERM ne '' then cmdecod = IRTERM;
	    if PRTR ne '' then cmdecod = PRTR;
run;

proc sort data=prev;
	by subjid cmdecod;
run;

data CM010;
	merge cm1001 (in=a) prev (in=b);
	by subjid cmdecod;
	if a;
	if SGDAT ne . and CMSTDAT ne . and SGDAT ge CMSTDAT then output;
	if ISGDAT ne . and CMSTDAT ne . and IRADEND ge CMSTDAT then output;
	if PREND ne . and CMSTDAT ne . and PREND ge CMSTDAT then output;
run;
data  CM010;
	retain SUBJID CMSPID CMTRT CMDECOD CMSTDAT CMENDAT CMONGO SGSPID SGPROC SGPROCO SGDAT IRADSPID IRADSTD IRADEND PRSPID PRTRT PRSTD PREND;
	set CM010;
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for duplicate and overlapping medications between Concomitant Therapy";
title2 "and Previous Therapy panels. If the same Therapy is recorded in Prior Therapy";
title3 "CRF (E.g.- CM2001), Prior Therapy's End Date must be < CM Start Date.";
  proc print data=CM010 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM010 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

