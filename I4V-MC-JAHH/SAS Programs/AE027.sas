/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AA027.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Sushil Kumar     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Proc Sql;
	Create Table AE as Select 
		A.SUBJID, 
		A.BLOCKID, 
		A.AETERM,
		A.AEGRPID,
		B.AESER,
		AESTDAT,
		AEENDAT
		
	From (Select * from Clntrial.AE3001a where AEGRPID ne .)as A Left Join Clntrial.AE3001b as B

	on A.SUBJID eq B.SUBJID and A.AEGRPID eq b.AEGRPID
;
	Create Table AE027 as Select 
		SUBJID, 
		BLOCKID, 
		AETERM,
		AEGRPID,
		AESER,
		AESTDAT,
		AEENDAT
		
	From AE 

	Group By SUBJID, AEGRPID

	Having Count(AEGRPID) GE 2

	Order by SUBJID, BLOCKID, AEGRPID, AESTDAT
;
Quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Events within the same AEGRPID";

  proc print data=AE027 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE027 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

