/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA705.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Output when there are less than 4 BGCONC recordings for the same BGDAT.”
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

/*eCOA705*/
/*Output when there are less than 4 BGCONC recordings for the same BGDAT.”*/

proc sql;
create table test_group as
select subjid format z4., sitecode, bgconc, bgdat, bgtim from
(select subjid, sitecode, bgdat, bgconc, bgtim from cluwe.bg2001_ecoa)
where bgdat is not null and bgconc is not null order by subjid, bgdat, bgtim; quit;

/****** Now count up bg samples by date n bg_nodup to merge with Alldates and dosecount***************/

data bgcount;
	set test_group;
		by subjid bgdat bgtim;		
			if first.bgdat then bgcount = 0;
			bgcount + 1;
		if last.bgdat and bgcount < 4 then output;
		drop sitecode bgconc bgtim;
proc sort; by subjid bgdat; run;


proc sql;
create table eCOA705 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', sitecode label 'Site', a.subjid label 'Subjid', bgconc, a.bgdat, bgtim, bgcount label 'Readings per BGDAT'
from (select subjid, sitecode, bgconc, bgdat, bgtim from test_group) a
inner join
(select subjid, bgdat, bgcount from bgcount) b
on a.subjid = b.subjid and a.bgdat = b.bgdat;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA705";
  title2 "Output when there are less than 4 BGCONC recordings for the same BGDAT.";

proc print data=eCOA705 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA705 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
