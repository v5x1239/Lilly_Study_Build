/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK101.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Review GLS Time Compared to Injection Time
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Check for duplicate PK/PD data in GLS.    If duplicate labs exist with same date and time of collections and different results and/or units.
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : External LAB, vitals, ex
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
	Create table PK101 as 
	select subjid, VISID, BLOCKID, UNSCHDLD, TSTCDNME, CLLCTDT, CLLCTTM
	from (select * from clntrial.LABRSLTA where LBTESTCD='HR6')
	group by subjid, VISID,CLLCTDT
	having count (CLLCTTM) gt 1;
quit;

	


/*Print PK101*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for duplicate PK/PD data in GLS. If duplicate";
  title2 "labs exist with same date and time of collections";
  title3 " and different results and/or units.";

  proc print data=PK101 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set PK101 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
