/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EXCMP011.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Number of days treatment missed must be < = number of days of the assessment interval
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : mh8001_f1
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
proc sort data=clntrial.ex1001 (Where = (page='EX1001_F25')) out=ex1;
	by subjid blockid;
run;

proc sort data = clntrial.sv1001 (KEEP =subjid blockid visdat) out=dov;
	by subjid blockid;
run;

data dov1;
	set dov;
	by subjid blockid;
	prev_dov= lag (DOV);
	if first.subjid then prev_dov = .;
	INTER = DOV-PREV_DOV;
run;


data EXCMP011;
	attrib
	prev_dov label = 'Previous Visit date'
	INTER label = 'Number of days of the assessment interval'
	miss label = 'Number of days treatment missed';
	merge ex1 (in=a keep=SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT) dov1 (in=b);
	by subjid blockid;
	if a;
	MISS = ECENDAT-ECSTDAT;
	if miss gt inter;
run;

data EXCMP011 (KEEP = SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT visdat miss INTER);
	retain SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT visdat miss INTER;
	set EXCMP011;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Number of days treatment missed must be < = number";
title2 "of days of the assessment interval";

proc print data=EXCMP011 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EXCMP011 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
