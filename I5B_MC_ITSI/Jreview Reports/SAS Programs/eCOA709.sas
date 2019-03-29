/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA709.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Check Pump if applicable to site. Compare pump model to country/site. 640G in Spain. 630 and 530G in US.”
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

/*eCOA709*/
/*Check Pump if applicable to site. Compare pump model to country/site. 640G in Spain. 630 and 530G in US.”*/

proc sql;
create table eCOA709 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', sitecode label 'Site', subjid label 'Subjid', ipmbrmodnm from CLUWE.IPM1001_ecoa
where (sitecode in ('108', '118', '134') and ipmbrmodnm = 'MINIMED 640G') or (sitecode in ('752', '753') and ipmbrmodnm in ('MINIMED 530G', 'MINIMED 630G'));
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA709";
  title2 "Check Pump if applicable to site. Compare pump model to country/site. 640G in Spain. 630 and 530G in US.";

proc print data=eCOA709 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA709 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
