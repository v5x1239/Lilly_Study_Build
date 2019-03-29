/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EXCMP012.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : The number of missing doses must be <= number of days of assessment interval  *dosing frequency
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


data EXCMP012;
	attrib
	prev_dov label = 'Previous Visit date'
	INTER label = 'Number of days of the assessment interval';
	merge ex1 (in=a keep=SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU) dov1 (in=b);
	by subjid blockid;
	if a;
	MISS = ECENDAT-ECSTDAT;
run;

data EXCMP012 (KEEP = SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU visdat miss );
	retain SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU visdat miss INTER;
	set EXCMP012;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "The number of missing doses must be <= number of days of assessment"; 
title2 "ointerval  *dosing frequency";

proc print data=EXCMP012 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EXCMP012 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
