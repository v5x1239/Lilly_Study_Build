/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR700.sas
PROJECT NAME (required)           : List of those subjects for which ‘diabetes’ is marked as ‘No’ on the Prespecified Medical History eCRF (both type 1 and type 2 are marked  ‘No’) with the respective subject’s list of concomitant medications.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
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

data MSR700_ MSR700_1 (keep=SUBJID);
	set clntrial.MHPRESP_;
	if MHLLTCDPRESP in ('10045228', '10045242') and MHOCCUR ='N' then output MSR700_;
	if MHLLTCDPRESP in ('10045228', '10045242') and MHOCCUR ='Y' then output MSR700_1;
run;
proc sort data=MSR700_;
	by SUBJID;
run;
proc sort data=MSR700_1;
	by SUBJID;
run;
data MSR700_2;
	merge MSR700_ (in=a) MSR700_1 (in=b);
	by SUBJID;
	if a and b then delete;
	if a;
run;
proc sort data=clntrial.DS1_DUMP out=ds;
	by SUBJID;
	where DSDECOD='SCREEN FAILURE';
run;
data MSR700_3;
	merge MSR700_2 (in=a) ds (in=b);
	by SUBJID;
	if a and b then delete;
	if a;
run;
proc sql;
	create table MSR700 as
		select distinct a.merge_datetime, a.SUBJID, a.MHOCCUR, a.MHLLTCDPRESP, b.CMTRT
			from MSR700_3 a left join clntrial.CM1001 b
			on a.SUBJID=b.SUBJID
		where datepart(a.MERGE_DATETIME) > input("&date",Date9.);

quit;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "List of those subjects for which ‘diabetes’ is marked as ‘No’";
title2 " on the Prespecified Medical History eCRF (both type 1 and";
title3 " type 2 are marked  ‘No’) with the respective subject’s list of concomitant medications.";

  proc print data=MSR700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
