/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM700.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Abortive Meds (per provided list) should not be recorded on the CM fom during Treatment Phase of the Trial  (Abortive Meds taken in the Follow-up Phase (V8 and V9) Start Date must be >=V7) 
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
data sv_dump (KEEP=SUBJID BLOCKID visdat);
	set clntrial. SV_DUMP;
	if BLOCKID=7;
run;

proc sql;
	create table CM700 as
		select a.merge_datetime,a.SUBJID, a.CMSPID,  a.CMTRT, a.CMTRADNM, a.CMSTDAT, a.CMDECOD, b.BLOCKID, b.visdat
			from clntrial.CM1001_d a left join SV_DUMP b
			on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID
				where datepart(MERGE_DATETIME) > input("&date",Date9.) and CMDECOD in ('ACETAMINOPHEN', 'ASPIRIN', 'IBUPROFEN', 
					'NAPROXEN', 'KETOPROFEN', 'CELECOXIB', 'DICLOFENAC', 'TRIPTANS', 'CORTICOSTEROIDS', 'DIHYDROERGOTAMINE', 'ERGOTAMINE',
					'ERGOT DERIVATIVES', 'INDOMETHACIN', 'INTRANASAL CAPSAICIN', 'INTRANASAL LIDOCAINE', 'METHYSERGIDE', 'OCTREOTIDE', 'OPIOIDS AND BARBITURATES',
					'OXYGEN', 'SOMATOSTATIN');
quit;


/*Print CM700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Abortive Meds (per provided list) should not be recorded";
title2 "on the CM fom during Treatment Phase of the Trial";
title3 "(Abortive Meds taken in the Follow-up Phase";
title4 "(V8 and V9) Start Date must be >=V7)";
  proc print data=CM700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
