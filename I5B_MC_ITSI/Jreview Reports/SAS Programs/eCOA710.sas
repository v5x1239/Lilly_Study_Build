/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA710.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : There must be at least 1 SMBG value before and after premature infusion set changes due to “SUSPECTED INFUSION SET OCCLUSION (UNEXPLAINED HIGH BG)” per protocol”
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itsi\data\shared\*.*
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

/*eCOA710*/
/*There must be at least 1 SMBG value before and after premature infusion set changes due to “SUSPECTED INFUSION SET OCCLUSION (UNEXPLAINED HIGH BG)” per protocol”*/

proc sql;
create table eCOA710 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', sitecode label 'Site', a.subjid label 'Subjid', IPMIFCHFDAT, IPMIFCHFTIM, IPMCHGINFSTPM, BGDAT, BGTIM, BGCONC from
(select sitecode, subjid, input(catx("-",IPMIFCHFDATMO,IPMIFCHFDATDD,IPMIFCHFDATYY),mmddyy10.) as IPMIFCHFDAT_DATE format date9., 
IPMIFCHFDAT, IPMIFCHFTIM, input(IPMIFCHFTIM, time11.) as IPMIFCHFTIM_TIME format time8., IPMCHGINFSTPM
from CLUWE.ipm1001_ecoa where IPMCHGINFSTPM = 'SUSPECTED INFUSION SET OCCLUSION (UNEXPLAINED HIGH BG)') a 
left join
(select subjid, input(catx("-",BGDATMO,BGDATDD,BGDATYY),mmddyy10.) as BGDAT_DATE format date9., BGDAT, input(BGTIM, time11.) as BGTIM_TIME format time8., BGTIM, BGCONC
from CLUWE.bg2001_ecoa) b
on a.subjid = b.subjid and a.IPMIFCHFDAT_DATE = b.BGDAT_DATE
where (IPMIFCHFTIM_TIME - BGTIM_TIME > 3600 OR IPMIFCHFTIM_TIME - BGTIM_TIME < -3600) OR BGCONC is null; 
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA710";
  title2 "There must be at least 1 SMBG value before and after premature infusion set changes due to “SUSPECTED INFUSION SET OCCLUSION (UNEXPLAINED HIGH BG)” per protocol";

proc print data=eCOA710 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA710 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
