/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon5.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Dump of HYPO panel
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

/*DIAB_eCOA_URI_Recon5*/

data DIAB_eCOA_URI_Recon5(keep=SUBJECT SITECODE VISIT VISITNUM ECOASTDT ECOAENDT ECOAASMDT HYOCCUR HYPOSTDAT
							   HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU BGCONCSTAT HYPOOUT_A HYPOOUT_B 
							   HYPOOUT_C HYPOOUT_D HYPOOUT_E HYPOOUT_F HYPOOUT_G HYPOACNOTH_B HYCONTRT HYPOTRT_A
							   HYPOTRT_B HYPOTRT_C HYPOTRT_D HYPOTRT_E HYPOTRTPRV HYPOSER HYPOEVAL CESPID HYTERM
							   HYOBJ FACAT HYPRESP HYPOCPH HYPOCPSH CECAT CESCAT);
retain SUBJECT SITECODE VISIT VISITNUM ECOASTDT ECOAENDT ECOAASMDT HYOCCUR HYPOSTDAT
							   HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU BGCONCSTAT HYPOOUT_A HYPOOUT_B 
							   HYPOOUT_C HYPOOUT_D HYPOOUT_E HYPOOUT_F HYPOOUT_G HYPOACNOTH_B HYCONTRT HYPOTRT_A
							   HYPOTRT_B HYPOTRT_C HYPOTRT_D HYPOTRT_E HYPOTRTPRV HYPOSER HYPOEVAL CESPID HYTERM
							   HYOBJ FACAT HYPRESP HYPOCPH HYPOCPSH CECAT CESCAT;
set CLUWE.HYPO1001_ECOA;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon5";
  title2 "Dump of HYPO panel";

proc print data=DIAB_eCOA_URI_Recon5 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon5 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
