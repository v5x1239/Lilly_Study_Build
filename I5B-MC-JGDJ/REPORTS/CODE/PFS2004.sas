/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PFS2004.sas
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
by subjid;
run;
data pfs;
set clntrial.PFS21001;
if pfs2dat ne . then
pfs2dat1 = datepart(pfs2dat);
if pfs2dat ne . then
date = datepart(pfs2dat);
format pfs2dat1 date date9.;
where pfs2dat ne .;
keep subjid pgstasmt pfs2dat1 PFSSTNA PDPDSTH date;
run;
proc sort;
by subjid date;
run;
data irad;
set clntrial.IRAD3001;
if IRADSTDAT ne . then
IRADSTDAT1  = datepart(IRADSTDAT);
format IRADSTDAT1 date9.;
if page eq 'IRAD3001_LF2';
keep subjid IRADSTDAT1;
run;
proc sort nodup;
by subjid;
run;
data sg;
set clntrial.SG1001B;
if SGDAT ne . then
SGDAT1  = datepart(SGDAT);
format SGDAT1 date9.;
if page eq 'SG1001_LF2';
keep subjid SGDAT1;
run;
proc sort nodup;
by subjid;
run;
data sys;
set clntrial.SYST3001;
if SYSTSTDT ne . then
SYSTSTDT1  = datepart(SYSTSTDT);
format SYSTSTDT1 date9.;
if page eq 'SYST3001_LF2';
keep subjid SYSTSTDT1;
run;
proc sort nodup;
by subjid;
run;
data all;
merge pfs(in = a) irad sg sys;
by subjid;
if a;
run;
proc sort;
by subjid date;
run;
data ds;
set clntrial.ds1001;
if dsstdat ne . then
date = datepart(dsstdat);
format date date9.;
if PROGTYPE ne '';
keep subjid PROGTYPE date;
run;
proc sort;
by subjid date;
run;
data fin1;
merge all(in = a) ds(in = b);
by subjid date;
if a;
run;
proc sort;
by subjid;
run;
data fin;
merge fin1(in = a) dm;
by subjid;
if a;
run;
data fin2;
set fin;
length flag $50.;
if PFS2DAT1 ne . and IRADSTDAT1 ne . and IRADSTDAT1 le PFS2DAT1 or PFS2DAT1 ne . and SGDAT1 ne . and SGDAT1 le PFS2DAT1  or 
PFS2DAT1 ne . and SYSTSTDT1 ne . and SYSTSTDT1 le PFS2DAT1 then flag = 'IRADSTDAT or SGDAT or SYSTSTDAT <= PFS2DAT';
run;
proc sql;
create table PFS2004 as select distinct SITEMNEMONIC 'Site Number', SUBJID 'Subject Number', pgstasmt 'Progression status assessed',
PFSSTNA 'Reason progression status not assessed', PFS2DAT1 as PFS2DAT format date9. 'Date of Assessment',PDPDSTH 'Progressed',
PROGTYPE 'Progression Type',IRADSTDAT1 'Start date-PR_IRAD_PD', SGDAT1 'Start date-PR_SG_PD', SYSTSTDT1 'Start date-CM_SYST_PD', Flag from fin2
order by subjid;
quit;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PFS";
  title2 "Ensure a new treatment has been started after initial progression";

proc print data=PFS2004 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set PFS2004 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
