/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH702.sas
PROJECT NAME (required)           : EIBHDESCRIPTION (required)            : For those subjects (Excluding Screen Failures) for which ASCVD = No but other conditions that may be associated with the “Disease Diagnostic Criteria” are = Yes 
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

proc sql;
	create table MH702 as
		select merge_datetime, SUBJID, MHOCCUR, MHLLTCDPRESP
			from clntrial.MHPRESP_ 
				where subjid in (select Distinct subjid from clntrial.MHPRESP_ b where MHLLTCDPRESP = '10051615' and MHOCCUR='N') and
					(MHLLTCDPRESP in ('10067825', '10022562', '10011078', 
					'10028596', '10046251', '10043821', '10042244', '10002892', '10007687', '10049194', '10065608', '10006894', '10053375', '10072568', '10061627')
					and MHOCCUR='Y') and  
					subjid not in (select Distinct subjid from clntrial.ds1001 where dsdecod eq 'SCREEN FAILURE') and datepart(MERGE_DATETIME) > input("&date",Date9.);

quit;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For those subjects (Excluding Screen Failures) for";
title2 "which ASCVD = No but other conditions that may be associated"
title3 "with the Disease Diagnostic Criteria are = Yes";

  proc print data=MH702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
