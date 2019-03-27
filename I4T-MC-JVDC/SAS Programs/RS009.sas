/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS009.sas
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

Data rs1;
set clntrial.RS1001;
if page eq 'RS1001_F1' and OVRLRESP ne ''; 
keep subjid RSSPID OVRLRESP;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs2;
set clntrial.RS1001;
if page eq 'RS1001_F1' and TRGRESP ne ''; 
keep subjid RSSPID TRGRESP;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs3;
set clntrial.RS1001;
if page eq 'RS1001_F1' and NTRGRESP ne ''; 
keep subjid RSSPID NTRGRESP;
run;
Proc sort;
by subjid RSSPID;
run;
data rs;
merge rs1 rs2 rs3;
by subjid RSSPID;
/*where RSSPID ne .;*/
run;
data rsfin1;
set rs;
if (OVRLRESP eq 'CR' and (TRGRESP ne 'CR' or NTRGRESP ne 'CR'));
run;
proc sort;
by subjid;
run;
data rsfin2;
set rs;
if (OVRLRESP eq 'PR' and TRGRESP ne 'PR');
run;
proc sort;
by subjid;
run;
data rsfin3;
set rs;
if (OVRLRESP eq 'PR' and TRGRESP ne 'CR' and NTRGRESP not in ('Non-CR/Non-PD','NOT ASSESSED'));
run;
proc sort;
by subjid;
run;
data rsfin4;
set rs;
if (OVRLRESP eq 'SD' and TRGRESP ne 'SD');
run;
proc sort;
by subjid;
run;
data rsfin5;
set rs;
if (OVRLRESP eq 'PD' and (TRGRESP ne 'PD' or NTRGRESP ne 'PD'));
run;
proc sort;
by subjid;
run;
data rsfin6;
set rs;
if (OVRLRESP eq 'NON-CR-NON-PD' and (TRGRESP ne 'Non-CR/Non-PD' or NTRGRESP ne 'Non-CR/Non-PD'));
run;
proc sort;
by subjid;
run;
data rsfin7;
set rs;
if (OVRLRESP eq 'NE' and TRGRESP ne 'NE');
run;
proc sort;
by subjid;
run;
data rsfin8;
set rs;
if (OVRLRESP eq '' and (TRGRESP ne '' or NTRGRESP ne ''));
run;
proc sort;
by subjid;
run;
data rsfin;
set rsfin1 rsfin2 rsfin3 rsfin4 rsfin5 rsfin6 rsfin7 rsfin8;
by subjid;
run;
proc sort;
by subjid;
run;
data all1;
merge rsfin(in = a) dm;
by subjid;
if a;
run;
data RS009;
retain SITEMNEMONIC subjid RSSPID OVRLRESP TRGRESP NTRGRESP; 
set all1;
keep SITEMNEMONIC subjid RSSPID OVRLRESP TRGRESP NTRGRESP;
run;
Proc sort nodup;
by subjid;
run;

/*Print RS009*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "Confirm Overall response provided agrees with responses recorded on both the Target and 
Non-Target responses with respect to Response criteria specified in the Protocol.";
  proc print data=RS009 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS009 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
