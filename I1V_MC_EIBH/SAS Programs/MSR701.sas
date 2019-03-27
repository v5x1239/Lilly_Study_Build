/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR701.sas
PROJECT NAME (required)           : List of those subject for which ASCVD is marked ‘No’ and the conditions on the Prespecified Medical History form that may indicate a disease diagnostic criteria (list below) are also marked as  ‘No’ with their list of concomitant medications. 
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
data a1_ (rename=(MHOCCUR=ASCVD));
	set clntrial.MHPRESP_;
	where MHLLTCDPRESP='10051615' and MHOCCUR ='N';
run;


proc sql;
	create table MSR701 as
		select distinct a.merge_datetime, a.SUBJID, a.ASCVD, b.MHOCCUR, b.MHLLTCDPRESP, c.CMTRT
			from a1_ a left join clntrial.MHPRESP_ b
			on a.SUBJID=b.SUBJID left join clntrial.CM1001 c
			on a.SUBJID=c.SUBJID
		where b.MHLLTCDPRESP in ('10067825','10022562','10011078','10028596','10046251','10043821','10042244','10002892','10007687','10049194','10065608',
'10006894','10053375','10072568','10061627') and b.MHOCCUR ='N' and datepart(a.MERGE_DATETIME) > input("&date",Date9.);
quit;
proc sort data=MSR701;
	by SUBJID;
run;
proc sort data=clntrial.DS1_DUMP out=ds;
	by SUBJID;
	where DSDECOD='SCREEN FAILURE';
run;
data MSR701;
	merge MSR701 (in=a) ds (in=b);
	by SUBJID;
	if a and b then delete;
	if a;
run;
/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "List of those subject for which ASCVD is marked ‘No’";
title2 " and the conditions on the Prespecified Medical History form";
title3 "that may indicate a disease diagnostic criteria (list below)";
title4 " are also marked as  ‘No’ with their list of concomitant medications.";

  proc print data=MSR701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
