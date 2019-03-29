/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : BMI_701.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Calculate a BMI to check that weight and height are logical.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Calculate a BMI to check that weight and height are logical.
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
data bmi;
	set clntrial.vs_dump;
	if upcase(WEIGHTU)='KG' and upcase (HEIGHTU)='CM' then 
	xx=(height/100)*(height/100);
run;
proc sql;
	create table BMI_701 as
	select subjid, BLOCKID, BLOCKRPT, PAGE, PAGERPT, VSDAT, HEIGHT, HEIGHTU, WEIGHT, WEIGHTU,
	(weight)/xx as BMI
	from bmi
	where upcase(WEIGHTU)='KG' and upcase (HEIGHTU)='CM' and calculated BMI ge 40 and datepart(MERGE_DATETIME) > input("&date",Date9.);
quit;
	


/*Print BMI_701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Calculate a BMI to check that weight and height are logical.";


  proc print data=BMI_701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set BMI_701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
