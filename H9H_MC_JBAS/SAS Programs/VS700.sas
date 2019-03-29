/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : VS700.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Verify weight changes of +/- 10% (or X kg) between assessments/visits/cycles.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        :VS1001
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
/*VS700*/

/*Add code here*/
proc sort data=clntrial.vs1001 (KEEP = SUBJID BLOCKID PAGE VSDAT WEIGHT WEIGHTU) out=vs1;
	by subjid blockid vsdat;
run;

data VS700;
	set vs1;
	by subjid blockid vsdat;
	prev_wt = lag (weight);
	if first.subjid then prev_wt = .;
	perc = ( ( prev_wt - weight ) / weight) * 100;
	if perc  ne . and (perc lt -10 or perc gt 10);
	
	 
run;


/*Print VS700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Verify weight changes of +/- 10% (or X kg) between assessments/visits/cycles.";
   proc print data=VS700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set VS700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
