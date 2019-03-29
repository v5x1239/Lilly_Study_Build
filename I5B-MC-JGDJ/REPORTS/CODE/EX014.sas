/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX014.sas
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
data ex10;
set clntrial.EX1001B;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
if EXENDAT ne . then
EXENDAT1 = datepart(EXENDAT);
if EXSTTIM ne '' then
EXSTTIM1 = input(EXSTTIM,time5.);
if EXENTIMH ne '' and length(EXENTIMI) eq 2 then
EXENTIM = input(trim(EXENTIMH)||':'||trim(EXENTIMI),time5.);
if EXENTIMH ne '' and length(EXENTIMI) eq 1 then
EXENTIM = input(trim(EXENTIMH)||':0'||trim(EXENTIMI),time5.);
format EXSTDAT1 EXENDAT1 date9. EXSTTIM1 EXENTIM time5.;
where page = 'EX1001_F2';
keep SUBJID blockid page EXSPID EXSTDAT1 EXSTTIM1 EXENDAT1 EXENTIMH EXENTIMI EXENTIM;
run;
proc sort;
by SUBJID EXSTDAT1 EXENDAT1;
run;
data ex1;
set ex10;
if EXSTDAT1 ne . then
EXSTDAT = EXSTDAT1;
if EXENDAT1 ne . then
EXENDAT = EXENDAT1;
format EXSTDAT EXENDAT date9.;
run;
proc sort;
by SUBJID EXSTDAT EXENDAT;
run;
data lag1;
set ex1;
by SUBJID EXSTDAT EXENDAT;
sub = lag(SUBJID);
stdt = lag(EXSTDAT);
endt = lag(EXENDAT);
sm = lag(EXSTTIM1);
em = lag(EXENTIM);
format stdt endt date9. sm em time5.;
run;
Data Duplicate_ex1;
	set lag1;
	length flag $50.;
	if (SUBJID eq sub) 
	and (((EXSTDAT ne . and stdt ne .) and (EXSTDAT ge stdt)
	and (EXSTDAT ne . and  endt ne . and EXSTDAT le endt))
	or 
	(((EXENDAT ne . and stdt ne . ) and (EXENDAT ge stdt)) and 
	((EXENDAT ne . and endt ne . ) and (EXENDAT le endt))
	or ((EXSTDAT ne . and  stdt ne .) and EXSTDAT eq stdt))
	or ((EXSTDAT ne . and  stdt ne . and endt eq .) and EXSTDAT ge stdt)) 
	then Flag1 = 'OVERLAPING DATE';
	if (SUBJID eq sub)  
	and EXSTDAT eq stdt  and EXENDAT eq endt then flag1 = 'DUPLICATE DATE';
	if (SUBJID eq sub) and EXSTDAT eq stdt  and EXENDAT eq endt and EXSTTIM1 ne . and EXSTTIM1 eq sm 
	and em eq EXENTIM then flag = 'Duplicate Date and Time';
	if (SUBJID eq sub) and EXSTDAT eq stdt  and EXENDAT eq endt and EXSTTIM1 ne . and EXSTTIM1 lt em  
	then flag = 'Overlapping Date and Time';
	Drop sub stdt endt;
Run;
data ex20;
set clntrial.EX1001B;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
if EXENDAT ne . then
EXENDAT1 = datepart(EXENDAT);
if EXSTTIM ne '' then
EXSTTIM1 = input(EXSTTIM,time5.);
if EXENTIMH ne '' and length(EXENTIMI) eq 2 then
EXENTIM = input(trim(EXENTIMH)||':'||trim(EXENTIMI),time5.);
if EXENTIMH ne '' and length(EXENTIMI) eq 1 then
EXENTIM = input(trim(EXENTIMH)||':0'||trim(EXENTIMI),time5.);
format EXSTDAT1 EXENDAT1 date9. EXSTTIM1 EXENTIM time5.;
where page in ('EX1001_LF1','EX1001_F3');
keep SUBJID blockid page EXSPID EXSTDAT1 EXSTTIM1 EXENDAT1 EXENTIMH EXENTIMI EXENTIM;
run;
proc sort;
by SUBJID EXSTDAT1 EXENDAT1;
run;
data ex2;
set ex20;
if EXSTDAT1 ne . then
EXSTDAT = EXSTDAT1;
if EXENDAT1 ne . then
EXENDAT = EXENDAT1;
format EXSTDAT EXENDAT date9.;
run;
proc sort;
by SUBJID EXSTDAT EXENDAT;
run;
data lag2;
set ex2;
by SUBJID EXSTDAT EXENDAT;
sub = lag(SUBJID);
stdt = lag(EXSTDAT);
endt = lag(EXENDAT);
format stdt endt date9.;
run;
Data Duplicate_ex2;
	set lag2;
	length flag $50.;
	if (SUBJID eq sub) 
	and (((EXSTDAT ne . and stdt ne .) and (EXSTDAT ge stdt)
	and (EXSTDAT ne . and  endt ne . and EXSTDAT le endt))
	or 
	(((EXENDAT ne . and stdt ne . ) and (EXENDAT ge stdt)) and 
	((EXENDAT ne . and endt ne . ) and (EXENDAT le endt))
	or ((EXSTDAT ne . and  stdt ne .) and EXSTDAT eq stdt))
	or ((EXSTDAT ne . and  stdt ne . and endt eq .) and EXSTDAT ge stdt)) 
	then Flag1 = 'OVERLAPING DATE';
	if (SUBJID eq sub)  
	and EXSTDAT eq stdt  and EXENDAT eq endt then flag1 = 'DUPLICATE DATE';
	if (SUBJID eq sub) and EXSTDAT eq stdt  and EXENDAT eq endt and EXSTTIM1 ne . and EXSTTIM1 eq sm 
	and em eq EXENTIM then flag = 'Duplicate Date and Time';
	if (SUBJID eq sub) and EXSTDAT eq stdt  and EXENDAT eq endt and EXSTTIM1 ne . and EXSTTIM1 lt em  
	then flag = 'Overlapping Date and Time';
	Drop sub stdt endt;
Run;
data ex;
set Duplicate_ex1 Duplicate_ex2;
run;
proc sort;
by subjid page EXSTDAT EXENDAT;
run;
data fin;
merge ex(in = a) dm;
by subjid;
if a;
run;
data EX014;
retain SITEMNEMONIC SUBJID blockid page EXSPID EXSTDAT EXSTTIM1 EXENDAT EXENTIM;
set fin;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' BlockID = 'Visit number' Page = 'Form name'
EXSPID = 'Sponsor defined identifier' EXSTDAT = 'Treament start date' EXSTTIM1 = 'Treatment start time'
EXENDAT = 'Treatment end date' EXENTIM = 'Treatment end time';
keep SITEMNEMONIC SUBJID blockid page EXSPID EXSTDAT EXSTTIM1 EXENDAT EXENTIM flag;
run;
proc sort;
by subjid page EXSTDAT EXENDAT;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "EX";
  title2 "Start date must be after end date of previous chronologic entry with same treatment name";

proc print data=EX014 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX014 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

