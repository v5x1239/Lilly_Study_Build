/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA712.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : If V18 is present in InForm, a Visit 18 MMTT record should be present in eCOA.
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrn\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

options compress=yes;

/************************* Start of environment/input/output programming ************************/

proc sql;
create table svstat as
select distinct sv.SUBJID, sv.blockid, input(sv.blockid, 8.) as VISITNUM format 8., stat.stat, input(catx("-",sv.VISDATMO,sv.VISDATDD,sv.VISDATYY),mmddyy10.) as VISDAT format date9.
from CLUWE.SV1001 sv, CLUWE.statgut stat
where sv.subjid = stat.subjid and sv.blockid = stat.blockid and sv.blockid = '18' and stat.stat = '500'
order by SUBJID, BLOCKID;
quit;

proc sort data = cluwe.ml1001_ecoa out=ml1001_ecoa(keep=SUBJID VISITNUM);
by SUBJID VISITNUM;
run;

data eCOA712(drop=visitnum);
retain SUBJID BLOCKID VISDAT STAT;
merge svstat(in=a) ml1001_ecoa(in=b);
by SUBJID VISITNUM;
if a and not b;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA712";
  title2 "If V18 is present in InForm, a Visit 18 MMTT record should be present in eCOA.";

proc print data=eCOA712 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA712 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

