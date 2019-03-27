/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            :  No identical terms with duplicate and overlapping dates can be recorded
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
	create table MH004 as 
	select distinct a.MERGE_DATETIME, A.subjid, A.MHTERM, B.MHDECOD,B.MHSTDAT, B.MHENDAT
		from clntrial.mh8001_d as A, clntrial.mh8001_d as B
		where 	A.subjid EQ B.subjid and 
				A.MHDECOD EQ B.MHDECOD and 
				A.MHSPID NE B.MHSPID and 
				(A.MHSTDAT = B.MHSTDAT and a.MHENDAT=b.MHENDAT) or (A.MHSTDAT gt B.MHSTDAT and A.MHSTDAT lt b.MHENDAT)
		union
		select distinct a.MERGE_DATETIME, A.subjid, A.MHTERM, A.MHDECOD,A.MHSTDAT, A.MHENDAT
		from clntrial.mh8001_d as A, clntrial.mh8001_d as B
		where 	A.subjid EQ B.subjid and 
				A.MHDECOD EQ B.MHDECOD and 
				A.MHSPID NE B.MHSPID and 
				(A.MHSTDAT = B.MHSTDAT and a.MHENDAT=b.MHENDAT) or (A.MHSTDAT gt B.MHSTDAT and A.MHSTDAT lt b.MHENDAT)
		order by subjid;
quit;
data MH004 ;
	set MH004 ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;


/*Print MH004*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "No identical terms with duplicate and overlapping dates can be recorded";

proc print data=MH004 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH004 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




