/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon1a.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : DIAB_eCOA_URI_Recon1a.
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

/*DIAB_eCOA_URI_Recon1a*/

data BG2001_1;
set BG2001;
where LBTPTREF is not null and BGCONC in (.,0.00) and BGCONC1 in (.,0.00) and BGCONC2 in (.,0.00);
run;

data DIAB_eCOA_URI_Recon1a(drop=BGDATE BGTIME);
retain SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
	   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2;
set BG2001_1;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon1a";
  title2 "Exception based report to identify missing BGCONC from BG1001";

proc print data=DIAB_eCOA_URI_Recon1a noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon1a nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
