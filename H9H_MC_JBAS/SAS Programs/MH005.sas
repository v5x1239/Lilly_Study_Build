/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH005.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of severity must be recorded or event must become serious
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
/*MH005*/

/*Add code here*/
proc sort data=clntrial.MH8001 (where=(MHONGO='Y')) out=mh1;
	by SUBJID MHSPID MHTERM mhdecod MHSTDAT;
run;


proc sql;
	create table AE as 
	select a.subjid, a.aegrpid, a.aeterm, a.aedecod,  b.AESTDAT, b.AEENDAT, b.AESER
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;

	
	create table mh005 as 
	select  a.SUBJID, a.MHSPID, a.MHTERM, a.mhdecod, a.MHSTDAT, b.aegrpid, b.aeterm,  b.aedecod, b.AESTDAT, b.AEENDAT, b.AESER
	from mh1 as a, ae as b
	where a.subjid=b.subjid and a.mhdecod=b.aedecod;
quit;	


/*Print MH005*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of severity must be recorded or event must become serious";
  proc print data=MH005 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH005 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
