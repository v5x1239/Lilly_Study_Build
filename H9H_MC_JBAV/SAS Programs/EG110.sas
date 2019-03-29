/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : eg110.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : Event Term for AEGGRPID_RELREC (or AEGGRPID_RELREC2 or AEGGRPID_RELREC3) in AE form must be a Cardiac Event   
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

/*eg110*/

data eg3001A(keep= SUBJID AEGRPREL AEGRPRL2 AEGRPRL3);
set clntrial.eg3001;
where AEGRPREL ne . or AEGRPRL2 ne . or AEGRPRL3 ne .;
proc sort; by subjid; run;

data AEGRPID_RELREC(keep=subjid varnm AEGRPID_RELREC_NUM);
format AEGRPID_RELREC_NUM 5. varnm $15.;
set eg3001a;
where AEGRPREL ne .;
AEGRPID_RELREC_NUM = AEGRPREL;
varnm = "AEGRPID_RELREC";
proc sort nodup; by subjid; run;

data AEGRPID_RELREC2(keep=subjid varnm AEGRPID_RELREC_NUM);
format AEGRPID_RELREC_NUM 5. varnm $15.;
set eg3001a;
where AEGRPRL2 ne .;
AEGRPID_RELREC_NUM = AEGRPRL2;
varnm = "AEGRPID_RELREC2";
proc sort nodup; by subjid; run;

data AEGRPID_RELREC3(keep=subjid varnm AEGRPID_RELREC_NUM);
format AEGRPID_RELREC_NUM 5. varnm $15.;
set eg3001a;
where AEGRPRL3 ne .;
AEGRPID_RELREC_NUM = AEGRPRL3;
varnm = "AEGRPID_RELREC3";
proc sort nodup; by subjid; run;

data ega;
retain subjid varnm AEGRPID_RELREC_NUM;
set AEGRPID_RELREC AEGRPID_RELREC2 AEGRPID_RELREC3;
proc sort nodup; by subjid varnm AEGRPID_RELREC_NUM; run;

data ae(keep=subjid AEGRPID_RELREC_NUM aegrpid aeterm aedecod);
set clntrial.ae3001a;
where aegrpid ne . and aedecod ne '';
AEGRPID_RELREC_NUM = aegrpid;
proc sort; by subjid AEGRPID_RELREC_NUM; run;

data eg110;
merge ega(in=a) ae(in=b);
by subjid AEGRPID_RELREC_NUM;
if a and b;
run;

/*Print eg110*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Event Term for AEGGRPID_RELREC (or AEGGRPID_RELREC2 or AEGGRPID_RELREC3) in AE form must be a Cardiac Event";
  proc print data=eg110 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set eg110 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
