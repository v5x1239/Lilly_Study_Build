/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon4.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Exception based report to identify where HYCONTRT = YES
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

/*DIAB_eCOA_URI_Recon4*/

data DIAB_eCOA_URI_Recon4(keep=SUBJECT SITECODE ECOAENDT HYOCCUR HYPOSTDAT HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU HYPOTRTPRV HYCONTRT HYPOEVAL HYTERM HYPRESP HYPOCPH); 
retain SUBJECT SITECODE ECOAENDT HYOCCUR HYPOSTDAT HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU HYPOTRTPRV HYCONTRT HYPOEVAL HYTERM HYPRESP HYPOCPH;
set CLUWE.HYPO1001_ECOA;
where upcase(HYCONTRT) = 'YES';
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon4";
  title2 "Exception based report to identify where HYCONTRT = YES";

proc print data=DIAB_eCOA_URI_Recon4 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon4 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
