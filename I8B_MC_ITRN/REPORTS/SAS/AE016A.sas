/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE027.sas
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
AESEV,AESER,AESDTH,AESLIFE,AESHOSP,AESDISAB,AESCONG,AESMIE,AEREL,AERELDVC,AEACN/*,AERELNST*/,AEOUT
from clntrial.AE3001B
order by SUBJID,AEGRPID;
quit;
proc sql;
create table ae as select distinct a.SUBJID,a.AEGRPID,a.AETERM,a.AEDECOD,b.AESPID,b.AESTDAT,b.AEONGO,b.AEENDAT,b.AESEV,b.AESER,b.AEOUT,
b.AESDTH,b.AESLIFE,b.AESHOSP,b.AESDISAB,b.AESCONG,b.AESMIE,b.AEREL,b.AERELDVC,b.AEACN/*,b.AERELNST*/
from ae1 a left join ae2 b 
on a.subjid = b.subjid and a.AEGRPID = b.AEGRPID
order by SUBJID,AEDECOD,AESTDAT;
quit;
proc sql;
create table a as select subjid ,count(subjid) as subj, AEGRPID, AESPID, AETERM,AEDECOD , AESTDAT , AEONGO, AEENDAT , AESEV , AESER ,AESDTH,AESLIFE , AESHOSP,
AESDISAB ,AESCONG , AESMIE , AEREL , AERELDVC , AEACN , AEOUT from ae
group by subjid ,AEDECOD , AESTDAT , AEONGO, AEENDAT , AESEV , AESER ,AESDTH,AESLIFE , AESHOSP,
AESDISAB ,AESCONG , AESMIE , AEREL , AERELDVC , AEACN , AEOUT
order by subjid, AEDECOD, AESTDAT;
quit;
data b;
set a;
length flag1 $30.;
if subj gt 1 and AETERM ne '' then flag1 = 'Duplicate Record';
run;
proc sort data = b;
by subjid AEDECOD AESTDAT;
run;
data lag;
set b;
by SUBJID AEDECOD AESTDAT;
sub = lag(subjid);
cod = lag(AEDECOD);
st = lag(AESTDAT);
ong = lag(AEONGO);
en = lag(AEENDAT);
format st en date9.;
run;
data fin1;
set lag;
length flag2 $30.;
if (SUBJID eq sub) and (AEDECOD eq cod) 
	and AESTDAT ne . and en ne . and AESTDAT <= en 
	then Flag2 = 'Overlapping Dates';
run;
data leads;
_n_ ++ 1;
if _n_ le n then do;
set fin1 point=_n_;
leadsub = subjid;
leadcod=AEDECOD;
leadst=AESTDAT;
leaden=AEENDAT; 
format leadst leaden date9.;
end;
set fin1 nobs=n;
run;
data l1;
set leads;
if leadsub eq subjid and AEDECOD ne '' and leadcod eq AEDECOD and AEENDAT ge leadst then flag2 = 'Overlapping Dates';
if flag1 ne '' and flag2 ne '' then flag2 = '';
run;
proc sort;
by subjid;
run;
data final;
merge l1(in = a) dm;
by subjid;
if a;
run;
proc sql;
create table AE027 as select SUBJID,AEGRPID,AETERM,AEDECOD,AESPID,AESTDAT,AEONGO,AEENDAT,AESEV,AESER,AESDTH,AESLIFE,AESHOSP,
AESDISAB,AESCONG,AESMIE,AEREL,AERELDVC,AEACN/*,AERELNST*/,AEOUT,flag1, flag2
from final
order by SUBJID,AEGRPID,AESTDAT;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "Separate Events (different AE group IDs) with the same LLT term and the same or overlapping date, should be verified.";

proc print data=AE027 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE027 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

