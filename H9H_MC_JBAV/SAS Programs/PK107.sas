/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK103.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : PK date not within protocol defined intervals
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

/***********************************************************************/
/*************              Programming Section           **************/
/***********************************************************************/

data ae(keep=subjid aegrpid aeterm aedecod aestdat cllctdt);
set clntrial.ae3001c;
where aegrpid ne . and aedecod = "Vomiting";
cllctdt = aestdat;
proc sort; by subjid cllctdt; run;

data pk;
set clntrial.LABRSLTA;
where LBTESTCD = "S45";
cllctdt = datepart(cllctdt);
format cllctdt date9. ;
proc sort; by subjid cllctdt; run;

data pk107;
merge pk(in=a) ae(in=b);
by subjid cllctdt;
if a and b;
run;

/*Print list of exception terms.*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Provide PK group with a listing of all subjects experiencing vomiting on the day of the dose.";
  proc print data=pk107 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set pk107 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
