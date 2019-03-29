/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM009.sas
PROJECT NAME (required)           : I9A_MC_JLDA
DESCRIPTION (required)            : EX - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001_all, DM1001_all
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        				 Code History Description
---- ------------    				 ------------------------------------------------------------------------
1.0  Paulraj Shanmugam            	 Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I9A_MC_JLDA;*/

/*EX701*/

/*Add code here*/

proc sql;
	create table CM009 as
		select SITEMNEMONIC, SUBJID, CMSPID, CMTRT, CMTRADNM, CMSTDAT, CMONGO, CMENDAT
		from clntrial.CM009_PS
	group by SUBJID, CMTRADNM, CMTRT, CMSTDAT, CMONGO, CMENDAT
	having count(*) gt 1;
quit;

/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If the same Therapy is recorded in several entries, at least one item of the records must be different from each other.";

  proc print data=CM009 noobs WIDTH=min; * Replace AA001 with report name;
    var _all_;
  run;

ods csv close;


/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM009 nobs=NUM; * Replace AA001 with report name;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
