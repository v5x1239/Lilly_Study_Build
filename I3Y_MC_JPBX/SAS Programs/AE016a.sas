/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE016a.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Separate Events (different AE group IDs) with the same LLT term and the same or overlapping date, should be verified.
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
	create table AE015a_ as 
	select distinct a.MERGE_DATETIME, a.subjid,a.AEGRPID,a.AETERM, a.AEDECOD, a.AELLT, b.AESTDAT, b.AEENDAT
			from clntrial.AE4_D as a left join clntrial.AE4001B as b
					on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
	order by a.subjid,	a.AEGRPID,b.AESTDAT;
quit;

proc sql;
	create table AE016a as 
	select distinct a.MERGE_DATETIME, A.subjid, b.AEGRPID,B.AETERM, B.AEDECOD,B.AELLT,B.AESTDAT,B.AEENDAT
		from AE015a_ as A, AE015a_ as B
		where 	A.subjid EQ B.subjid and 
				A.AEDECOD EQ B.AEDECOD and 
				A.AEGRPID NE B.AEGRPID and 
				(A.AESTDAT = B.AESTDAT and a.AEENDAT=b.AEENDAT) or (A.AESTDAT gt B.AESTDAT and A.AESTDAT lt b.AEENDAT)
		union
		select distinct a.MERGE_DATETIME, A.subjid, a.AEGRPID,A.AETERM, A.AEDECOD,A.AELLT,A.AESTDAT,A.AEENDAT
		from AE015a_ as A, AE015a_ as B
		where 	A.subjid EQ B.subjid and 
				A.AEDECOD EQ B.AEDECOD and 
				A.AEGRPID NE B.AEGRPID and 
				(A.AESTDAT = B.AESTDAT and a.AEENDAT=b.AEENDAT) or (A.AESTDAT gt B.AESTDAT and A.AESTDAT lt b.AEENDAT)
		order by subjid;
quit;
data AE016a ;
	set AE016a ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;


/*Print AE016a*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Separate Events (different AE group IDs) with the same LLT term";
	title2 "and the same or overlapping date, should be verified.";

proc print data=AE016a noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE016a nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




