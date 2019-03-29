/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : I5B_MC_JGDJ
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A, AE4001B
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by SUBJID;
run;
data mh1;
set clntrial.MH004_P;
if MHSTDAT ne . then
MHSTDAT1 = datepart(MHSTDAT);
if MHENDAT ne . then
MHENDAT1 = datepart(MHENDAT);
format MHSTDAT1 MHENDAT1 date9.;
where page ='MH8001_LF1';
keep SUBJID MHSPID MHTERM MHDECOD MHSTDAT1 MHENDAT1 MHONGO MHTOXGR MHCTCV4 startdate enddate;
run;
proc sort;
by SUBJID MHDECOD MHSTDAT1 MHENDAT1;
run;
data mh;
set mh1;
if MHSTDAT1 ne . then
MHSTDAT = MHSTDAT1;
if MHENDAT1 ne . then
MHENDAT = MHENDAT1;
format MHSTDAT MHENDAT date9.;
run;
proc sort;
by SUBJID MHDECOD MHSTDAT MHENDAT;
run;
data lag1;
set mh;
by SUBJID MHDECOD MHSTDAT MHENDAT;
sub = lag(SUBJID);
trm = lag(MHDECOD);
stdt = lag(MHSTDAT);
endt = lag(MHENDAT);
format stdt endt date9.;
run;
Data Duplicate_mh;
	set lag1;
	length flag $20.;
	if (SUBJID eq sub) and (trm eq MHDECOD) 
	and (((MHSTDAT ne . and stdt ne .) and (MHSTDAT ge stdt)
	and (MHSTDAT ne . and  endt ne . and MHSTDAT le endt))
	or 
	(((MHENDAT ne . and stdt ne . ) and (MHENDAT ge stdt)) and 
	((MHENDAT ne . and endt ne . ) and (MHENDAT le endt))
	or ((MHSTDAT ne . and  stdt ne .) and MHSTDAT eq stdt))
	or ((MHSTDAT ne . and  stdt ne . and endt eq .) and MHSTDAT ge stdt)) 
	then Flag = 'OVERLAPING';
	if (SUBJID eq sub) and (trm eq MHDECOD) 
	and MHSTDAT eq stdt  and MHENDAT eq endt then flag = 'DUPLICATE';
	Drop sub stdt endt trm;
Run;
proc sort;
by subjid MHDECOD MHSTDAT MHENDAT;
run;
data fin;
merge Duplicate_mh(in = a) dm;
by subjid;
if a;
run;
data MH004;
retain SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD startdate enddate MHONGO MHTOXGR MHCTCV4;
set fin;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' MHSPID = 'MH Number' MHTERM = 'Medical History Term' 
MHDECOD = 'Dictionary Derived Term' startdate = 'Start date' enddate = 'End date' MHONGO = 'Ongoing'
MHTOXGR = 'CTCAE grade' MHCTCV4 = 'CTCAE Code';
keep SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD startdate enddate MHONGO MHTOXGR MHCTCV4 flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "MH";
  title2 "No identical terms with duplicate and overlapping dates can be recorded";

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

