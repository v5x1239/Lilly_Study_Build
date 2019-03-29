/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX005b.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : Every treatment record must be unique (must have at least one difference in a value or a field).
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Sushil kumar     Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data EX1001;
	set clntrial.EX1001;
run;

proc sort data=EX1001 nodupkey dupout=EX1005;
	by SUBJID BLOCKID BLOCKRPT EXSPID EXTRT EXCAT EXSTDAT EXSTTM EXENDAT EXENTM EXTPT EXOCCUR EXDOSE EXLOT EXDOSEU AEGRPRL4 AEGRPRL3 AEGRPRL2 AEGRPREL ;
run;

proc Sql;
	Create table EX005b as Select *
	/*strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,*/
	
	from EX1005

	/* where datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, BLOCKID, BLOCKRPT, EXSPID
	
;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Every treatment record must be unique";
	title2 " (must have at least one difference in a value or a field).";

proc print data=EX005b noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX005b nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
