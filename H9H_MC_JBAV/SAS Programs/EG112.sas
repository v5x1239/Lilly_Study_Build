/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : eg112.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : Event Term for EGMHNO (or EGMHNO2 or EGMHNO3) in MH form must be a Cardiac Event    
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
/*************                Setup Section               **************/
/***********************************************************************/

/*eg112*/

data eg3001b(keep= subjid EGMHNO EGMHNO2 EGMHNO3);
set clntrial.eg3001;
where EGMHNO ne . or EGMHNO2 ne . or EGMHNO3 ne .;
proc sort; by subjid; run;

data EGMHNO(keep=subjid varnm EGMHNO_NUM);
format EGMHNO_NUM 5. varnm $7.;
set eg3001b;
where EGMHNO ne .;
EGMHNO_NUM = EGMHNO;
varnm = "EGMHNO";
proc sort nodup; by subjid; run;

data EGMHNO2(keep=subjid varnm EGMHNO_NUM);
format EGMHNO_NUM 5. varnm $7.;
set eg3001b;
where EGMHNO2 ne .;
EGMHNO_NUM = EGMHNO2;
varnm = "EGMHNO2";
proc sort nodup; by subjid; run;

data EGMHNO3(keep=subjid varnm EGMHNO_NUM);
format EGMHNO_NUM 5. varnm $7.;
set eg3001b;
where EGMHNO3 ne .;
EGMHNO_NUM = EGMHNO3;
varnm = "EGMHNO3";
proc sort nodup; by subjid; run;

data egb;
retain subjid varnm EGMHNO_NUM;
set EGMHNO EGMHNO2 EGMHNO3;
proc sort nodup; by subjid varnm EGMHNO_NUM; run;

data mh(keep=subjid EGMHNO_NUM mhspid mhterm mhdecod);
format EGMHNO_NUM 5.;
set clntrial.mh7001;
where mhspid ne '' and mhdecod ne '';
EGMHNO_NUM = input(mhspid,5.);
proc sort; by subjid EGMHNO_NUM; run;

data eg112;
merge egb(in=a) mh(in=b);
by subjid EGMHNO_NUM;
if a and b;
run;

/*Print eg112*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Event Term for EGMHNO (or EGMHNO2 or EGMHNO3) in MH form must be a Cardiac Event";
  proc print data=eg112 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set eg112 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
