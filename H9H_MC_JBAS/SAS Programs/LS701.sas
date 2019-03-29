/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LS701.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Ensure "assessment number" starts at '1' for each response and are sequential for multiple assessments performed.

SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : TU2001, TU5001,TU3001, TU6001      
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
/*LS701*/

data LS701;
	set clntrial.RS1001 (DROP=RSDATDD RSDATMO RSDATYY) clntrial.IRRC1001 (DROP=RSDATDD RSDATMO RSDATYY);
	
run;

/*Print LS701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure "assessment number" starts at '1' for each";
title2 "response and are sequential for multiple assessments performed.";


  proc print data=LS701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LS701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
