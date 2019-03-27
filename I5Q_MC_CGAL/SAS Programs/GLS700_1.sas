/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS700.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Review GLS Time Compared to Injection Time
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required � study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : External LAB
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
	create table ex as
	select distinct a.SUBJID, a.EXSTDAT, a.extime
	from clntrial.EX1001_g a
	order by a.SUBJID;
quit;
data gls;
set clntrial.LABRSLTA;
if length(compress(put(CLLCTTM,best.),'')) eq 3 then 
cltime = input('0'||substr(compress(put(CLLCTTM,best.),''),1,1)||':'||substr(compress(put(CLLCTTM,best.),''),2,2),time5.);
if length(compress(put(CLLCTTM,best.),'')) eq 4 then 
cltime = input(substr(compress(put(CLLCTTM,best.),''),1,2)||':'||substr(compress(put(CLLCTTM,best.),''),3,2),time5.);
format cltime time5.;
keep SUBJID CLLCTDT CLLCTTM cltime;
run;
proc sort;
by subjid;
run;
data gls1;
merge ex(in = a) gls(in = b);
by subjid;
if a and b;
run;
data gls700;
retain SUBJID EXSTDAT extime CLLCTDT CLLCTTM;
set gls1;
if EXSTDAT eq CLLCTDT and input(extime,time5.) lt cltime;
keep SUBJID EXSTDAT extime CLLCTDT CLLCTTM;
run;


/*Print GLS700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Review GLS Time Compared to Injection Time";

  proc print data=GLS700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
