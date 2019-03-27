/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS024.sas
PROJECT NAME (required)           : I4T_MC_JVDC
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;

Data rs;
set clntrial.RS1001;
spid = RSSPID;
if page eq 'RS1001_F1' and NTRGRESP eq 'PD'; 
keep subjid RSSPID NTRGRESP spid;
run;
Proc sort;
by subjid spid;
run;
data tu;
set clntrial.tu3001b;
spid = TRSPID;
keep subjid TUMSTATN TRSPID TRLNKID spid;
run;
Proc sort;
by subjid spid;
run;
data rstu;
merge rs(in = a) tu;
by subjid spid;
if a;
run;
data fin;
set rstu;
if TUMSTATN in ('UNEQUIVOCAL PROGRESSION') 
then flag = '#';
run;
proc sort data = fin out = fin1;
by subjid;
where flag ne '';
run;
proc sort data = fin out = fin2;
by subjid;
where flag eq '';
run;
proc sql;
create table mer as select subjid,count(subjid) as cnt from fin1
group by subjid,flag
order by subjid
;
quit;
data all;
merge fin mer;
by subjid;
run;
data all1;
merge all(in = a) dm;
by subjid;
if a;
run;
data RS024;
retain SITEMNEMONIC subjid RSSPID NTRGRESP TRSPID TRLNKID TUMSTATN; 
set all1;
if cnt eq .;
keep SITEMNEMONIC subjid RSSPID NTRGRESP TRSPID TRLNKID TUMSTATN;
run;
Proc sort;
by subjid;
run;

/*Print RS024*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Non-Target Response is Progressive Disease, ensure that one or more Non-Target tumors have tumor state Unequivocal Progression";
  proc print data=RS024 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS024 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
