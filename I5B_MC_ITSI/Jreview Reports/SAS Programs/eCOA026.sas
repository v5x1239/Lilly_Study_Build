/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA026.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Patient reported  “SUBJECT CAPABLE OF TREATING SELF AND RECEIVED ASSISTANCE” and serious column is blank. Show the report by patient and site ”
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

/*eCOA026*/
/*Patient reported  “SUBJECT CAPABLE OF TREATING SELF AND RECEIVED ASSISTANCE” and serious column is blank. Show the report by patient and site ”*/

proc sql;
create table eCOA026 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', SITECODE label 'Site', SUBJID label 'Subject ID', 
HYPOSTDAT, HYPOSTTIM, ECOASTDT, HYPOTRTPRV, HYPOSER 
from CLUWE.hypo1001_ecoa where HYPOTRTPRV = 'SUBJECT CAPABLE OF TREATING SELF AND RECEIVED ASSISTANCE' and HYPOSER is null; quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA026";
  title2 "Patient reported  “SUBJECT CAPABLE OF TREATING SELF AND RECEIVED ASSISTANCE” and serious column is blank. Show the report by patient and site ";

proc print data=eCOA026 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA026 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
