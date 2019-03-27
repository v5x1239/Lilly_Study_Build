/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS100.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : CONDITIONAL - IF CRITICAL FOR ANALYSIS (REFER TO SAP): Check for duplicate lab/PK data.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Add code here*/
proc sql;
	create table GLS100 as
	select SUBJID, VISID,BLOCKID,RQSTNTYP,PRCDRCD,LBTESTCD,CLLCTDT
	from (select * from clntrial.LABRSLTA where PRCDRCD ne 'STYDRG')
	group by SUBJID, VISID,BLOCKID,RQSTNTYP,PRCDRCD,LBTESTCD,CLLCTDT
	having count (*) gt 1;
quit;


/*Print GLS100*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for duplicate lab/PK data.";

proc print data=GLS100 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS100 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




