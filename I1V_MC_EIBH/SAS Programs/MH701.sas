/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH701.sas
PROJECT NAME (required)           : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : For items ASCVD (Item 1), Diabetes Mellitus, Type I (Item 3) or Diabetes Mellitus, Type II (Item 5) at least one must be recorded as 'Yes' to meet study eligibility. (Excludes SF Patients)
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : MHPRESP
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
data MH701a (KEEP=merge_datetime SUBJID MHLLTCDPRESP MHOCCUR)
	MH701b (KEEP=merge_datetime SUBJID MHLLTCDPRESP MHOCCUR)
	MH701c (KEEP=merge_datetime SUBJID MHLLTCDPRESP MHOCCUR);
	set clntrial.MHPRESP_ ;
	if MHLLTCDPRESP = '10051615' then output MH701a;
	if MHLLTCDPRESP = '10045228' then output MH701b;
	if MHLLTCDPRESP = '10045242' then output MH701c;
run;

proc sort data=MH701a;
	by subjid;
run;
proc sort data=MH701b;
	by subjid;
run;
proc sort data=MH701c;
	by subjid;
run;	
	
data MH701_;
	merge MH701a (rename=(MHLLTCDPRESP=MHLLTCDPRESP25_F1 MHOCCUR=MHOCCUR25)) MH701b (rename=(MHLLTCDPRESP=MHLLTCDPRESP2 MHOCCUR=MHOCCUR2)) 
		MH701c (rename=(MHLLTCDPRESP=MHLLTCDPRESP3 MHOCCUR=MHOCCUR3));
	by subjid;
	if MHOCCUR25='N' and MHOCCUR2='N' and MHOCCUR3='N';
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;
proc sort data=clntrial.ds1001 out=ds100;
	by subjid;
	where dsdecod eq 'SCREEN FAILURE';
run;
data MH701;
	merge MH701_ (in=a) ds100 (in=b keep=subjid);
	by subjid;
	if a and b then delete;
	if a;
run;
	


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For items ASCVD (Item 1), Diabetes Mellitus, Type I";
title2 "(Item 3) or Diabetes Mellitus, Type II (Item 5) at least"
title3 "one must be recorded as 'Yes' to meet study eligibility. (Excludes SF Patients)";

  proc print data=MH701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

