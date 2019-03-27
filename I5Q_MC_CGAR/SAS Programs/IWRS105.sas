/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : IWRS105.sas
PROJECT NAME (required)           : I5Q_MC_CGAR
DESCRIPTION (required)            : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
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
1.0  Joe Cooney        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data ivrs_(keep=subjid blockid_ivrs invid ivrsvsdt);
set clntrial.ivrs_cga;
blockid_ivrs = blockid;
proc sort; by subjid ivrsvsdt; run;

data ivrs;
set ivrs_;
by subjid ivrsvsdt;
if last.subjid then output; 
proc sort; by subjid; run;

data sv(keep=subjid blockid visitnum visdat);
set clntrial.SV_DUMP;
proc sort; by subjid blockid;
run;

data ds(keep=subjid blockid dsdecod);
set clntrial.DS1_DUMP;
proc sort; by subjid blockid;
run;

data dssv;
merge ds(in=a) sv(in=b);
by subjid blockid;
if a and b;
run;

data dssvivrs;
merge ivrs(in=a) dssv(in=b);
by subjid;
if a and b;
run;

proc sql;
create table IWRS105 as 
select b.SITEMNEMONIC, a.subjid, a.blockid_ivrs, a.invid, a.ivrsvsdt, a.blockid, a.dsdecod, a.visdat
from dssvivrs a left join clntrial.DM1001d b
	on a.SUBJID=b.SUBJID
	where a.ivrsvsdt > a.visdat 
order by b.SITEMNEMONIC, a.SUBJID, a.blockid_ivrs; 
quit;

/*Print IWRS105*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Verify that the discontinuation visit in InForm";
title2 "is at least one visit after the last drug dispensing visit in IWRS";
  proc print data=IWRS105 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set IWRS105 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
