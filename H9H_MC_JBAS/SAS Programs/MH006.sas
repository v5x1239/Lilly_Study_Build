/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH006.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If identical term is entered in MH and AE forms that is not ongoing on the MH form, then the AE start date must be greater than 1 day after MH stop date
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
/*MH006*/

/*Add code here*/
proc sort data=clntrial.MH8001 (where=(MHONGO='N')) out=mh1;
	by SUBJID MHSPID MHTERM mhdecod MHSTDAT;
run;


proc sql;
	create table AE as 
	select a.subjid, a.aegrpid, a.aeterm, a.aedecod,  b.AESTDAT, b.AEENDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;

	
	create table MH006 as 
	select  a.SUBJID, a.MHSPID, a.MHTERM, a.mhdecod, a.MHSTDAT, b.aegrpid, b.aeterm,  b.aedecod, b.AESTDAT, b.AEENDAT
	from mh1 as a, ae as b
	where a.subjid=b.subjid and a.mhdecod=b.aedecod and b.aestdat lt (1+a.MHSTDAT);
quit;	


/*Print MH006*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If identical term is entered in MH and AE forms that is not ongoing on the MH form, then the AE start date must be greater than 1 day after MH stop date";
  proc print data=MH006 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH006 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
