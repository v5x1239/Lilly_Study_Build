/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE072.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : When patient died, all Adverse Events must have a stop date prior to the death date OR checked YES, except the Adverse Event, indicated as the cause of death. 
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
proc sort data=clntrial.ae_dump (keep=merge_datetime SUBJID AEGRPID AETERM AEDECOD AEENDAT) out=ae;
	by SUBJID;

run;
proc sort data=clntrial.DS1_DUMP (keep=SUBJID DSDECOD DTHDAT) out=ds;
	by SUBJID;
run;

data AE072;
	merge ae (in=a) ds (in=b);
	by SUBJID;
	if a;
	if not missing (DTHDAT);
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

/*Print AE072*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "When patient died, all Adverse Events must have a stop date";
title2 "prior to the death date OR checked YES, except";
title3 "the Adverse Event, indicated as the cause of death.";

  proc print data=AE072 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE072 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
