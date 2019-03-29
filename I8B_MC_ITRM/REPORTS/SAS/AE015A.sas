/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE015A.sas
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
create table ae2 as select distinct SUBJID,AEGRPID,AESPID,datepart(AESTDAT) as AESTDAT format date9.,AEONGO, datepart(AEENDAT) as AEENDAT format date9.
from clntrial.AE3001B
order by SUBJID,AEGRPID;
quit;
proc sql;
create table ae as select distinct a.SUBJID,a.AEGRPID,a.AETERM,a.AEDECOD,b.AESPID,b.AESTDAT,b.AEONGO,b.AEENDAT
from ae1 a left join ae2 b 
on a.subjid = b.subjid and a.AEGRPID = b.AEGRPID
order by SUBJID,AEGRPID,AESPID;
quit;
data lag;
set ae;
by SUBJID AEGRPID AESPID;
sub = lag(subjid);
id = lag(AEGRPID);
spd = lag(AESPID);
ong = lag(AEONGO);
st = lag(AESTDAT);
en = lag(AEENDAT);
format st en date9.;
run;
data fin;
set lag;
length flag1 flag2 $100.;
if subjid eq sub and id eq AEGRPID and AESPID ne spd and AESTDAT ne en then flag1 = 'Start Date of second chronologic entry is NOT = End Date previous chronologic entry';
if subjid eq sub and id eq AEGRPID and AESPID ne spd and AESTDAT ne . and ONG eq 'Y' then flag2 = 'Start Date of second chronologic entry is completed but AEONGO = YES for previous chronologic entry';
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
create table AE015A as select SUBJID,AEGRPID,AETERM,AEDECOD,AESPID,AESTDAT,AEONGO,AEENDAT,flag1,flag2
from final where flag1 is not null or  flag2 is not null
order by SUBJID,AEGRPID,AESTDAT;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "Entries within the same event (AEGRPID) must have consecutive gapless durations:
Start Date second chronologic entry= End Date previous chronologic entry";

proc print data=AE015A noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE015A nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

