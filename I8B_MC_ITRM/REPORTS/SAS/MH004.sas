/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
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
data mh;
set clntrial.mh7001;
if MHSTDAT ne . then
MHSTDAT1 = datepart(MHSTDAT);
if MHENDAT ne . then
MHENDAT1 = datepart(MHENDAT);
format MHSTDAT1 MHENDAT1 date9.;
if MHSPID ne .;
keep SUBJID MHSPID MHTERM MHDECOD MHSTDAT1 MHONGO MHSEV MHENDAT1 MHLLT DICT_DICTVER MHSTDAT_C MHENDAT_C;
run;
proc sort;
by SUBJID MHDECOD MHSTDAT1;
run;
proc sql;
create table mh1 as select *,count(subjid) as cnt from mh
group by SUBJID,MHDECOD,MHSTDAT1,MHONGO,MHSEV,MHENDAT1,MHLLT,DICT_DICTVER
order by SUBJID,MHDECOD,MHSTDAT1,MHONGO,MHSEV,MHENDAT1,MHLLT,DICT_DICTVER;
quit;
data lag;
set mh1;
by SUBJID MHDECOD MHSTDAT1;
length flag2 flag1 $30.;
sub = lag(subjid);
trm = lag(MHDECOD);
st = lag(MHSTDAT1);
en = lag(MHENDAT1);
format st en date9.;
if MHDECOD ne '' and cnt gt 1 then flag1 = 'Duplicate Record';
if sub eq subjid and MHDECOD ne '' and trm eq MHDECOD and MHSTDAT1 ne . and en ne . and MHSTDAT1 <= en then flag2 = 'Overlapping Dates';
run;
proc sort;
by SUBJID MHDECOD MHSTDAT1;
run;
data leads;
_n_ ++ 1;
if _n_ le n then do;
set lag point=_n_;
leadsub = subjid;
leadcod=MHDECOD;
leadst=MHSTDAT1;
leaden=MHENDAT1; 
format leadst leaden date9.;
end;
set lag nobs=n;
run;
data l1;
set leads;
if leadsub eq subjid and MHDECOD ne '' and leadcod eq MHDECOD and MHENDAT1 ge leadst then flag2 = 'Overlapping Dates';
run;
proc sort;
by SUBJID MHDECOD MHSTDAT1;
run;
data final;
merge l1(in = a) dm;
by subjid;
if a;
run;
data MH004;
retain SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD MHSTDAT_C MHONGO MHSEV MHENDAT_C MHLLT DICT_DICTVER flag1;
set final;
if flag1 ne '' and flag2 ne '' then flag2 = '';
if flag1 ne '' or flag2 ne '';
keep SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD MHSTDAT_C MHONGO MHSEV MHENDAT_C MHLLT DICT_DICTVER flag1 flag2;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Pre-Existing Conditions and Medical History";
  title2 "No identical terms with duplicate and overlapping dates can be recorded.";

proc print data=MH004 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set MH004 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

