/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA001.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Check site/subject numbers in eCOA datasets against inform.
SPECIFICATIONS (required)         : DEV Ticket
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

/************************* Start of environment/input/output programming ************************/

options nofmterr;

/*eCOA001*/
/*Check site/subject numbers in eCOA datasets against inform*/

proc sort nodupkey data=CLUWE.eCOA_HEADER out=header001; by SUBJID sitecode; run;

proc sql;
create table svsite as
select distinct sv.SUBJID, st.SITEMNEMONIC, st.SITEMNEMONIC as sitecode length=19,
stat.stat
from CLUWE.inf_subject sb, CLUWE.inf_site_update st, CLUWE.SV1001 sv, CLUWE.statgut stat
where sb.SITEGUID=st.CT_RECID and sv.subject_id=sb.subject_id and sv.subjid = stat.subjid and 
sv.blockid = stat.blockid and stat.blockid = '2' and stat.stat = '100'
order by SUBJID, SITEMNEMONIC;
quit;

data eCOA001a(keep=SUBJECT SITECODE FLAG) eCOA001b(keep=SUBJID SITEMNEMONIC FLAG);
format FLAG $200.;
merge header001(in=a) svsite(in=b);
by SUBJID sitecode;
if a and not b then do;
	FLAG = 'In Header, not in InForm';
	output eCOA001a;
end;
if b and not a then do;
	FLAG = 'In Inform, not in Header';
	output eCOA001b;
end;
run;

data eCOA001;
set eCOA001a eCOA001b;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA001";
  title2 "Check site/subject numbers in eCOA datasets against inform";

proc print data=eCOA001 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA001 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
