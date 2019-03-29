/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon1b.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Exception based report to identify missing Meals from BG1001
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : \\IX1LECFS02.rf.lilly.com\icon.grp\DS_END\219268_I8B-MC-ITRM\ecoa\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

/************************* Start of environment/input/output programming ************************/

/*DIAB_eCOA_URI_Recon1_PREP*/

data BG2001(keep=SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
							   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2 BGDATE BGTIME);
set CLUWE.BG2001_ECOA;
BGDATE = COALESCEC(BGDAT, BGDAT1, BGDAT2);
BGTIME = COALESCEC(BGTIM, BGTIM1, BGTIM2);
proc sort; by SUBJECT BGDATE BGTIME; run;

/*DIAB_eCOA_URI_Recon1b*/

data bg2001a(keep = SUBJECT BGDATE LBTPTREF_MORNING);
set bg2001;
where LBTPTREF = 'MORNING MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_MORNING;
run;

data bg2001b(keep = SUBJECT BGDATE LBTPTREF_MIDDAY);
set bg2001;
where LBTPTREF = 'MIDDAY MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_MIDDAY;
run;

data bg2001c(keep = SUBJECT BGDATE LBTPTREF_EVENING);
set bg2001;
where LBTPTREF = 'EVENING MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_EVENING;
run;

data BG2001_2;
merge BG2001(in=a) BG2001a BG2001b BG2001c;
by SUBJECT BGDATE;
if a;
run;

data BG2001_2a;
set BG2001_2;
where BGDATE is not null and (LBTPTREF_MORNING is null or LBTPTREF_MIDDAY is null or LBTPTREF_EVENING is null);
drop LBTPTREF_MORNING LBTPTREF_MIDDAY LBTPTREF_EVENING;
run;

data DIAB_eCOA_URI_Recon1b(drop=BGDATE BGTIME);
retain SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
	   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2;
set BG2001_2a;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon1b";
  title2 "Exception based report to identify missing Meals from BG1001";

proc print data=DIAB_eCOA_URI_Recon1b noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon1b nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
