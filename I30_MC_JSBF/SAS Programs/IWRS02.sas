/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : 
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Identify missing forms and/or visits by comparing visits in study drug 
									dispensing system (that is, Interactive Web Response System (IWRS)/e-CTS)
									with visits in Inform.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : ivrs DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Cooney        Original version of the code - 20160926


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data ivrs(keep=subjid ivrsvis vis);
format vis $50. ivrsvis 6.;
set clntrial.IVRSTSA;
where blockid in (0,11,21,31,41,51,61,71,81,91);
ivrsvis = blockid;
vis = substr(compress(put(ivrsvis,7.)),1,1);
proc sort; by subjid vis; run;

data sv1001(keep=subjid blockid VISDATDD VISDATMO VISDATYY vis);
set clntrial.sv1001;
where blockid in ("0","1","2","3","4","5","6","7","8","9");
vis = blockid;
proc sort; by subjid vis; run;

data ivrs02a;
format flag $200.;
merge ivrs(in=a) sv1001(in=b);
by subjid vis;
if a and not b;
Flag = "In IVRS and not SV1001";
run;

data ivrs02b;
format flag $200.;
merge ivrs(in=a) sv1001(in=b);
by subjid vis;
if b and not a;
Flag = "In SV1001 and not IVRS";
run;

data ivrs02c;
format flag $200.;
merge ivrs(in=a) sv1001(in=b);
by subjid vis;
if a and b and VISDATDD = "" and VISDATMO = "" and VISDATYY = "";
Flag = "In IVRS and SV1001 but VISDAT missing";
run;

data iwrs02;
retain subjid ivrsvis blockid VISDATDD VISDATMO VISDATYY;
set ivrs02a ivrs02b ivrs02c;
drop vis;
run;

/*Print iwrs02*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Identify missing forms and/or visits by comparing visits in study drug dispensing system (that is, Interactive Web Response System (IWRS)/e-CTS) with visits in Inform.";
title2 " ";
  proc print data=iwrs02 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set iwrs02 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
