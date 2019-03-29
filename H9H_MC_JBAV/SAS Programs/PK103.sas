/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK103.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : PK date not within protocol defined intervals
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

/***********************************************************************/
/*************              Programming Section           **************/
/***********************************************************************/

data ex(keep=subjid blockid page EXTPTREF EXSTDAT EXSTDATlow EXSTDAThigh);
format blockid2 best12.;
set clntrial.ex1001;
where page = 'EX1001_F3' and EXTPTREF = "DOSE AFTER PK DRAW";
EXSTDAT_ = trim(compress(EXSTDATD,'')||'/'||compress(EXSTDATM)||'/'||compress(EXSTDATY)||''||compress(EXSTTIMH)||":"||compress(EXSTTIMI));
EXSTDAT = input(EXSTDAT_, anydtdtm.);
format EXSTDAT EXSTDATlow EXSTDAThigh datetime20. ;
EXSTDAThigh = EXSTDAT + 7200;
EXSTDATlow = EXSTDAT - 1800;
blockid2 = input(blockid, 12.);
drop blockid;
rename blockid2 = blockid;
proc sort; by subjid blockid; run;

data pk(keep=subjid blockid cllctdt);
set CLNTRIAL.LABRSLTA;
where LBTESTCD = "S45";
proc sort; by subjid blockid; run;

data pk103_;
merge pk(in=a) ex(in=b);
by subjid blockid;
if a;
run;

data pk103(keep=subjid blockid cllctdt page EXTPTREF EXSTDAT);
retain subjid blockid cllctdt page EXTPTREF EXSTDAT;
set pk103_;
where cllctdt < EXSTDATlow or cllctdt > EXSTDAThigh;
run;

/*Print list of exception terms.*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "PK date not within protocol defined intervals";
  proc print data=pk103 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set pk103 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
