/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TRF503.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Ensure AE is an appropriate event for the transfusion. (AEID/MHID)
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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

/*Add code here*/

proc sql;
	create table TRF503 (drop=STATUS ENTRY_ID ENTRY_DATETIME CT_RECID DB_ID SUBJECT_ID CTS_REASON) as
	select distinct a.subjid 'Subject number', PRSPID 'Sequence Identifier', TRFSTD 'Transfusion Start Date', 
	TRFBLDP 'Transfused blood product', TRFUNITS 'Number of transfused units',
	AEGRPID 'AE group ID', AETERM 'Adverse Event term', MHSPID 'MH group ID', MHTERM 'Medical history/event'
	from clntrial.trf_d a left join clntrial.MH8001_D b
	on a.subjid=b.subjid and a.MHNO=b.MHSPID left join clntrial.AE_DUMP c
	on a.subjid=c.subjid and a.AEGRPID_RELREC=c.AEGRPID
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.) and not missing (PRSPID)
	order by SUBJID;
quit;



/*Print TRF503*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure AE is an appropriate event";
title2 "for the transfusion. (AEID/MHID)";


  proc print data=TRF503 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TRF503 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




