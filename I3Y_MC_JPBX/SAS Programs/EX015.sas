/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX015.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : For the same treatment name, consecutive entries must be detected across the CRF. i.e.- start date of the second entry must be 1 day after the end date of the previous entry.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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
	create table EX015 as 
	select distinct a.MERGE_DATETIME, A.subjid, b.EXSPID,b.EXCAT, B.EXTRT, B.EXSTDAT,B.EXENDAT
		from clntrial.EX1001_D as A, clntrial.EX1001_D as B
		where 	A.subjid EQ B.subjid and 
				A.EXTRT EQ B.EXTRT and 
				A.EXSPID NE B.EXSPID and 
				A.EXSTDAT le b.EXENDAT
		union
		select distinct a.MERGE_DATETIME, A.subjid, a.EXSPID,a.EXCAT, a.EXTRT, a.EXSTDAT,a.EXENDAT
		from clntrial.EX1001_D as A, clntrial.EX1001_D as B
		where 	A.subjid EQ B.subjid and 
				A.EXTRT EQ B.EXTRT and 
				A.EXSPID NE B.EXSPID and 
				A.EXSTDAT le b.EXENDAT
		order by subjid;
quit;
data EX015 ;
	set EX015 ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;


/*Print EX015*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For the same treatment name, consecutive entries must be detected";
	title2 "across the CRF. i.e.- start date of the second entry must be 1";
	title3 "day after the end date of the previous entry.";

proc print data=EX015 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX015 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




