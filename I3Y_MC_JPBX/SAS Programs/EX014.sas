/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX014.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Start date must be after end date of previous chronologic entry with same treatment name
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
	create table EX014 as 
	select distinct a.MERGE_DATETIME, A.subjid, b.EXSPID,b.EXCAT, B.EXTRT, B.EXSTDAT,B.EXENDAT
		from clntrial.EX1001_D as A, clntrial.EX1001_D as B
		where 	A.subjid EQ B.subjid and 
				A.EXTRT EQ B.EXTRT and 
				A.EXSPID NE B.EXSPID and 
				(A.EXSTDAT = B.EXSTDAT and a.EXENDAT=b.EXENDAT) or (A.EXSTDAT gt B.EXSTDAT and A.EXSTDAT lt b.EXENDAT)
		union
		select distinct a.MERGE_DATETIME, A.subjid, a.EXSPID,a.EXCAT, a.EXTRT, a.EXSTDAT,a.EXENDAT
		from clntrial.EX1001_D as A, clntrial.EX1001_D as B
		where 	A.subjid EQ B.subjid and 
				A.EXTRT EQ B.EXTRT and 
				A.EXSPID NE B.EXSPID and 
				(A.EXSTDAT = B.EXSTDAT and a.EXENDAT=b.EXENDAT) or (A.EXSTDAT gt B.EXSTDAT and A.EXSTDAT lt b.EXENDAT)
		order by subjid;
quit;
data EX014 ;
	set EX014 ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;


/*Print EX014*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Start date must be after end date of previous chronologic";
	title2 " entry with same treatment name";

proc print data=EX014 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX014 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




