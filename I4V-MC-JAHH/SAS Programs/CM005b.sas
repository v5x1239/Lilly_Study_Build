/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM005b.sas
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


proc sql;
	create table CMSI as 
	select a.SUBJID, a.CMTRT, a.CMINDC, a.CMAEGRPID4, a.CMMHNO4, a.CMDECOD, a.CMTRADNM, a.CMCLAS, a.CMCLASCD,
		   b.CMONGO, b.CMSTDAT, b.CMENDAT, b.CMDOSE, b.CMDOSEU, b.CMDOSFRQ, b.CMROUTE
	from clntrial.CMSI1A a, clntrial.CMSI1B b
	where a.subjid = b.subjid and a.CMGRPID = b.CMGRPID;
quit;

data CMSI1001(keep=/*MERGE_DATETIME*/ SUBJID CMTRT CMINDC CMAEGRPID4 CMMHNO4 CMDECOD CMTRADNM CMCLAS CMCLASCD
		    CMONGO CMSTDAT CMENDAT CMDOSE CMDOSEU CMDOSFRQ CMROUTE AEID SPID);
set CMSI;
AEID = CMAEGRPID4;
SPID = CMMHNO4;
proc sort; by subjid AEID; run;

data ae3001(keep=SUBJID AEGRPID AETERM AEID);
set clntrial.ae3001a;
AEID = AEGRPID;
proc sort; by subjid AEID; run;

data aecm;
merge CMSI1001(in=a) ae3001(in=b);
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

data aecmmhex(keep=/*MERGE_DATETIME*/ SUBJID CMTRT CMSTDAT CMENDAT CMINDC CMAEGRPID4 CMMHNO4 CMDOSE CMDOSEU CMDOSFRQ CMROUTE CMDECOD CMTRADNM CMCLAS CMCLASCD EXSTDAT AETERM MHTERM);
retain /*MERGE_DATETIME*/ SUBJID CMTRT CMSTDAT CMENDAT CMINDC CMAEGRPID4 CMMHNO4 CMDOSE CMDOSEU CMDOSFRQ CMROUTE CMDECOD CMTRADNM CMCLAS CMCLASCD EXSTDAT AETERM MHTERM; 
merge aecmmh(in=a) ex1001(in=b);
by subjid;
if a;
run;

proc sql;
create table CM005b as 
select b.SITEMNEMONIC, a.*
from aecmmhex a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
/*	where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID; 
quit;

/*Print CM005b*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Equal Therapies (CMTRT) must have the same Standardized Medication Name ";
  title2 "(WHO Drug Dictionary term- Preferred Term) across the study.";

  proc print data=CM005b noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM005b nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
