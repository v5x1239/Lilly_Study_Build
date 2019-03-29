/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM008.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Study drug should not be recorded on this CRF.
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

data cm1001;
set clntrial.CM1001;
keep SUBJID CMSPID CMTRT CMSTDAT CMONGO CMENDAT CMINDC CMMHNO4
	 CMDECOD CMTRADNM CMCLAS CMCLASCD;
run;

proc sql;
create table CM008 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, a.CMSPID, a.CMTRT, 
	a.CMSTDAT, a.CMONGO, a.CMENDAT, a.CMINDC, a.CMMHNO4,
	a.CMDECOD, a.CMTRADNM, a.CMCLAS, a.CMCLASCD
from CM1001 a left join clntrial.DM1001c/*INF_SITE_ALL*/ b
on a.SUBJID=b.SUBJID
where strip(upcase(a.CMTRT)) in ('RAMUCIRUMAB', 'CISPLATIN', 'GEMCITABINE', 'MERESTINIB')
order by b.SITEMNEMONIC, a.SUBJID, a.CMTRT
; quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print CM008*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Concomitant Medication Name";
title2 "Study drug should not be recorded on this CRF.";
  proc print data=CM008 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM008 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
