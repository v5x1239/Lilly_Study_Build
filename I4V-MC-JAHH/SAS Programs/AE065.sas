/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE065.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : AE065 - If Event Outcome is 'Recovered with Sequelae', there must not be any entry with the same AEGRPID
									and Start date after that entry's End Date.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A_F1, AE4001B_F1
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
		B.AEOUT,
		B.AESTDAT,
		B.AEENDAT
		
	From (Select * from Clntrial.AE3001a where AEGRPID ne .)as A Left Join Clntrial.AE3001b as B

	on A.SUBJID eq B.SUBJID and A.AEGRPID eq B.AEGRPID

;
	Create Table AE1 as Select 
		SUBJID, 
		BLOCKID, 
		AETERM,
		AEGRPID,
		AESER,
		AEOUT,
		AESTDAT,
		AEENDAT
		
	From AE 

	Where upcase(Strip(AEOUT)) eq 'RECOVERED/RESOLVED WITH SEQUELAE'
;
	Create Table AE065 as Select 
		A.SUBJID, 
		A.BLOCKID, 
		A.AETERM,
		A.AEGRPID,
		A.AESER,
		A.AEOUT,
		A.AESTDAT,
		A.AEENDAT
		
	From AE1 as A, AE as B 

	Where A.SUBJID eq B.SUBJID and A.AEGRPID eq B.AEGRPID and A.AESTDAT GE B.AEENDAT

	Order by SUBJID, BLOCKID, AEGRPID, AESTDAT
;
Quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "If Event Outcome is 'Recovered with Sequelae', there must not be any entry with the same AEGRPID and Start date after that entry's End Date.";

  proc print data=AE065 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE065 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

