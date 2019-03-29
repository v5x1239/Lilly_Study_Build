/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE062.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
proc sql;
create table ae1 as select distinct SUBJID,AEGRPID,AETERM,AEDECOD from clntrial.AE3001A
order by SUBJID,AEGRPID;
quit;
proc sql;
create table ae2 as select distinct SUBJID,AEGRPID,AESPID,datepart(AESTDAT) as AESTDAT format date9.,AEONGO, datepart(AEENDAT) as AEENDAT format date9.,
AESEV,AESER,AEOUT
from clntrial.AE3001B
order by SUBJID,AEGRPID;
quit;
proc sql;
create table ae0 as select distinct a.SUBJID,a.AEGRPID,a.AETERM,a.AEDECOD,b.AESPID,b.AESTDAT,b.AEONGO,b.AEENDAT,b.AESEV,b.AESER,b.AEOUT
from ae1 a left join ae2 b 
on a.subjid = b.subjid and a.AEGRPID = b.AEGRPID
order by SUBJID,AEGRPID,AESPID;
quit;
proc sql;
create table ae01 as select *,count(subjid) as cnt from ae0
group by SUBJID,AEGRPID,AESPID
order by SUBJID,AEGRPID,AESPID;
quit;
data ae;
set ae01;
if cnt eq 1 and AEOUT in ('RECOVERING OR RESOLVING','NOT RECOVERED OR NOT RESOLVED','UNKNOWN');
run;
data fin;
set ae;
length flag $30.;
if AEONGO eq 'N' then flag = 'AEONGO is NOT Yes';
run;
proc sort;
by subjid;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
proc sql;
create table AE062 as select SUBJID,AEGRPID,AETERM,AEDECOD,AESPID,AESTDAT,AEONGO,AEENDAT,AESEV,AESER,AEOUT,flag
from final where flag is not null
order by SUBJID,AEGRPID,AESTDAT;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "For events with no changes in severity or in Seriousness (E.g.- Only one entry), 
If Event Outcome = 'Not Recovered/ Not Resolved', 'Recovering/ Resolving' or 'Unknown',ongoing must be selected as Yes.";

proc print data=AE062 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE062 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

