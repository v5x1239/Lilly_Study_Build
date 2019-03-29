/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE017.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : Check coding consitent per term in AE/MH
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM
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

/*****************************AE017**************************************/

data ae;
set clntrial.ae3001a;
where aeterm ne '';

if aeterm ne '' then term = aeterm;

if aedecod ne '' then decod = aedecod;
decod_x = decod;
proc sort nodup; by term; run;

data mh;
set clntrial.mh7001;
where mhterm ne '';

if mhterm ne '' then term = mhterm;

if mhdecod ne '' then decod = mhdecod;
decod_x = decod;
proc sort nodup; by term; run;

data aemh(keep=subjid term decod);
set ae mh;
proc sort nodupkey; by term; run;

data ae017(keep=subjid aeterm aedecod mhterm mhdecod decod_x);
retain subjid aeterm aedecod mhterm mhdecod decod_x;
merge aemh(in=a) ae mh;
by term;
if a and decod ne decod_x;
proc sort; by subjid decod_x; run;

/*Print da030*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check coding consitent per term in AE/MH";
  proc print data=ae017 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set ae017 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
