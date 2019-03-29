/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM007a.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : If any excluded medications, as defined in protocol, 
									are reported as part of the subject's Therapy, 
									they must be documented as Protocol Deviations.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney     Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I4V_MC_JAHH;*/


data cm1001(keep=/*MERGE_DATETIME*/ SUBJID CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMINDC CMAEGID4 CMMHNO4 CMROUTE CMDECOD CMTRADNM CMCLAS CMCLASCD AEID SPID);
set clntrial.cm1001;
AEID = CMAEGID4;
SPID = CMMHNO4;
proc sort; by subjid AEID; run;

data ae3001(keep=SUBJID AEGRPID AETERM AEID);
set clntrial.ae3001a;
AEID = AEGRPID;
proc sort; by subjid AEID; run;

data aecm;
merge cm1001(in=a) ae3001(in=b);
by subjid AEID;
if a;
proc sort; by subjid SPID; run;

data mh7001(keep=subjid MHTERM MHSPID SPID);
set clntrial.mh7001;
SPID = MHSPID;
proc sort; by subjid SPID; run;

data aecmmh;
merge aecm(in=a) mh7001(in=b);
by subjid SPID;
if a;
proc sort; by subjid; run;

data ex1001(keep=SUBJID EXSTDAT);
set clntrial.ex1001;
where page = "EX1001_LF6";
proc sort; by subjid; run;

data aecmmhex(keep=/*MERGE_DATETIME*/ SUBJID CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMINDC CMAEGID4 CMMHNO4 CMROUTE CMDECOD CMTRADNM CMCLAS CMCLASCD EXSTDAT AETERM MHTERM);
retain /*MERGE_DATETIME*/ SUBJID CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMINDC CMAEGID4 CMMHNO4 CMROUTE CMDECOD CMTRADNM CMCLAS CMCLASCD EXSTDAT AETERM MHTERM; 
merge aecmmh(in=a) ex1001(in=b);
by subjid;
if a;
run;

proc sql;
create table CM007a as 
select b.SITEMNEMONIC, a.*
from aecmmhex a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
/*	where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID; 
quit;

/*Print CM007a*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If any excluded medications as defined in protocol,";
  title2 "are reported as part of the subject's Therapy";
  title3 "they must be documented as Protocol Deviations.";

  proc print data=CM007a noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM007a nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
