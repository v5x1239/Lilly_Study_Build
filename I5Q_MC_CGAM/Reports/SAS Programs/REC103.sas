/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC103.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Ensure that all scheduled labs, ECGs and PK  are mapped to the correct visit.  Verify the mapping of GLS lab and ECG visit numbers based on collection date versus visit date.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
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
data dov (KEEP=SUBJID1 BLOCKID1 VISDAT);
	set clntrial.SV1001;
	BLOCKID1=input(BLOCKID, ??best.);
	rename SUBJID=SUBJID1;
run;

proc sort data=dov;
	by SUBJID1 BLOCKID1;
run;


proc transpose data=dov out=dov_;
	by SUBJID1;
	id BLOCKID1;
	var VISDAT;
run;

proc sql;
	create table REC103 (drop=SUBJID1 _name_ _label_) as
	select distinct a.SUBJID, a.BLOCKID, a.UNSCHDLD, a.CLLCTDT, b._1, b._2, b._3, b._4, b._5, b._6, b._7, b._8,b._9,/*b._10,b._11,b._12,b._13,b._14,b._15,
	b._16,b._17,b._18,b._19,b._20,b._21,b._22,b._23,b._24,*/ b._999 
	from clntrial.LABRSLTA a left join dov_ b
	on a.SUBJID=b.SUBJID1
	order by a.SUBJID;

quit;
	


/*Print REC103*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure that all scheduled labs, ECGs and PK  are mapped";
  title2 " to the correct visit.  Verify the mapping of GLS lab";
  title3 " and ECG visit numbers based on collection date versus visit date.";

  proc print data=REC103 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC103 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
