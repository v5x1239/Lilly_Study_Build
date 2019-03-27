/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE709.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If  AE start date = date of injection received in V3 or V9
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

/**/

libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I5Q_MC_CGAM;

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
data ex ;
	set clntrial.EX1001_all;
	if BLOCKID in ('3','9');
run;
proc sql;
	create table ae as
	select a.SUBJID,a.AEGRPID,a.AETERM,B.AEREL,b.AESTDAT
from clntrial.ae3001a_all a left join clntrial.ae3001b_all b
on a.subjid=b.subjid and a.AEGRPID = b.AEGRPID
where AEREL='Y';
quit;

proc sql;
	create table ae1 as
	select a.SUBJID,a.AEGRPID,a.AETERM,a.AEREL,a.AESTDAT,B.AESTEXRES1,b.BLOCKID
from ae a left join clntrial.AESTEX1001_all b
on a.subjid=b.subjid
where AESTEXRES1='N';
quit;

proc sql;
	create table AE709 as 
select distinct a.MERGE_DATETIME, a.SUBJID, a.AEGRPID, AETERM, AEREL,AESTDAT, b.blockid, EXSTDAT,AESTEXRES1
from ae1 a inner join ex b
on a.subjid=b.subjid and EXSTDAT=AESTDAT;
quit;



/*Print AE709*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If  AE start date = date of injection received in V3 or V9";

  proc print data=AE709 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE709 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
