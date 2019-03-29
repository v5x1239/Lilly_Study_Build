/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH700.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : 1. Ensure any ongoing MH events have a logical CTCAE code assigned per the CTCAEV4CD Codelist beased on the reported event.
				    2. Ensure that if there is a change to MH event was reported in AE, the MedDRA terms and CTCAE codes in the MH and AE record must match.  
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : MH8001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
/*MH700*/

/*Add code here*/
proc sort data=clntrial.MH8001 (KEEP= SUBJID MHSPID MHTERM mhdecod CTCLLTCD MHLLT MHLLTCD) out=mh1;
	by SUBJID MHSPID MHTERM mhdecod CTCLLTCD MHLLT MHLLTCD;
run;


proc sql;
	create table AE as 
	select a.subjid, a.aegrpid, a.aeterm, a.aedecod, a.AEDECOD, a.CTCLLTCD as AECTCV4,a.AELLT,a.AELLTCD, b.AESTDAT, b.AEENDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;

	
	create table MH700 as 
	select  a.*, b.*
	from mh1 as a, ae as b
	where a.subjid=b.subjid and a.mhdecod=b.aedecod;
quit;	


/*Print MH700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "1. Ensure any ongoing MH events have a logical CTCAE code assigned per the CTCAEV4CD Codelist beased on the reported event.";
  title2 "2. Ensure that if there is a change to MH event was reported in AE, the MedDRA terms and CTCAE codes in the MH and AE record must match.";
  proc print data=MH700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
