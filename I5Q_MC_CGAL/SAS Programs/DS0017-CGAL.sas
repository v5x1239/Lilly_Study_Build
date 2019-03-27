/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS0017.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Confirm that there are no other CRF dates after the LTF date (exclude AE, ConMed and visit dates as these are already checked with standard edits)
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Confirm that there are no other CRF dates after the LTF date (exclude AE, ConMed and visit dates as these are already checked with standard edits)
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
	create table DS0017 as
	select distinct a.merge_datetime, a.SUBJID, a.BLOCKID, a.DSDECOD, b.BLOCKID, b.VISDAT
	from (select *, b.VISDAT as VISDAT_ from clntrial.DS1_DUMP a left join clntrial.SV_DUMP b 
	on a.SUBJID=b.SUBJID where DSDECOD= 'LOST TO FOLLOW-UP') a left join clntrial.SV_DUMP b
	on a.SUBJID=b.SUBJID
	where b.VISDAT gt a.VISDAT_ and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by a.SUBJID;

quit;
	


/*Print DS0017*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Confirm that there are no other CRF dates after";
  title2 "the LTF date (exclude AE, ConMed and visit dates";
  title3 "as these are already checked with standard edits)";

  proc print data=DS0017 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS0017 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
