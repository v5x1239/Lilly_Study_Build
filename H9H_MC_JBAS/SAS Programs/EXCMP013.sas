/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EXCMP013.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : The number of missing doses must be equal or less than (number of missed days * number of total daily doses)
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
data EXCMP013 (keep=SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU MISS);
	attrib
	miss label = 'Number of days treatment missed';
	set clntrial.ex1001 (Where = (page='EX1001_F25'));
	MISS = ECENDAT-ECSTDAT;
run;

data EXCMP013;
	retain SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU MISS;
	set EXCMP013;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "The number of missing doses must be equal or less than";
title2 "(number of missed days * number of total daily doses) ";

proc print data=EXCMP013 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EXCMP013 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
