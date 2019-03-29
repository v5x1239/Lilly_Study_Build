/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC101.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Review GLS Time Compared to Injection Time
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Ensure that multiple unscheduled GLS lab procedures with the same visit number designation begin with "A" and include sequential unscheduled designations (A, B, C, D, and so forth in GLS).
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
	create table REC101 as
	select distinct a.SUBJID, a.BLOCKID, a.UNSCHDLD, a.CLLCTDT, b.BLOCKID, b.VISDAT
	from clntrial.LABRSLTA a left join clntrial.SV1001 b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.VISITNUM
	where not missing (a.UNSCHDLD)
	order by a.SUBJID;

quit;
	


/*Print REC101*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure that multiple unscheduled GLS lab procedures ";
  title2 "with the same visit number designation begin with A and";
  title3 "include sequential unscheduled designations (A, B, C, D, and so forth in GLS).";

  proc print data=REC101 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC101 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
