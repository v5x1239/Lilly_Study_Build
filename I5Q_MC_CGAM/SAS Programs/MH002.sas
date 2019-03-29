/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH002.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If Yes is selected, then past and/or concomitant diseases or  past surgeries need to be recorded.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
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
proc sort data=clntrial.MCH1001_ (keep=SUBJID MCHMED MCHERGOT MERGE_DATETIME) out=MCH1001;
	where MCHMED eq 'N' and MCHERGOT ne '';
	by SUBJID;
run;

proc sort data=clntrial.MHPRESP1 (keep=SUBJID MHOCCUR MHNUMEPISD MERGE_DATETIME)   out=MHPRESP1001;
	where MHOCCUR eq 'N' and MHNUMEPISD ne .;
	by SUBJID;
run;

data MH002 (Keep=SUBJID MHOCCUR MCHMED MCHERGOT MHNUMEPISD MCHMED MERGE_DATETIME);
	set MCH1001 MHPRESP1001;
	by SUBJID;
	message="Yes is selected, But past and/or concomitant diseases or past surgeries are not recorded.";
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;
	


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Yes is selected, then past and/or concomitant";
  title2 "diseases or  past surgeries need to be recorded.";

  proc print data=MH002 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH002 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
