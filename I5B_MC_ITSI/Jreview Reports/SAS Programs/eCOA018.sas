/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA018.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Report to output if BGDAT < start of study
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

/*eCOA018*/
/*Report to output if BGDAT < start of study*/

proc sql;
create table eCOA018 as
select  SITECODE label 'Site Code', SUBJID label 'Subject ID', ECOASTDT label 'eCOA Completion Start Date/Time',
BGDAT label 'BG Monitoring Date', input('21FEB2018',date9.) as STUDY_START_DATE format date9. label 'Study Start Date' from
(select subjid, sitecode, ECOASTDT, input(catx("-",substr(bgdat,6,2),substr(bgdat,9,2),substr(bgdat,1,4)),mmddyy10.) as bgdat format date9.,
bgconc, bgtim, lbtptref from cluwe.bg2001_ecoa)
where (bgdat is not null and bgdat < input('21FEB2018',date9.)) order by subjid, bgdat; quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA018";
  title2 "Report to output Blood Gluclose readings per patient per day from visit 2 till end of study";

proc print data=eCOA018 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA018 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

