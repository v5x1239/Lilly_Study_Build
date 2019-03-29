/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS028.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : If Overall response is confirmed “Complete response”, subsequent responses cannot be Stable Disease or Partial Response
									
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
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
1.0  Sushil kumar     Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/


/**** Listing 1 ****/
data RS;
	length Flag $200;
	set clntrial.RS1001(rename=(RSCATREC=RSCAT)) clntrial.IRRC1001(rename=(RSCTIRRC=RSCAT IRRCRESP=OVRLRESP));
	if A then Flag = 'Listing #1';
	else if B then  Flag = 'Listing #2';
	else if C then  Flag = 'Listing #3'; 
run;


/** Final Report **/
proc sql;
	create table RS028 as select *

	from RS

	/*where datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, RSDAT, RSSPID
;
quit;


/*Print RS028*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Overall response is confirmed “Complete response”,";
	title2 "subsequent responses cannot be Stable Disease or Partial Response";

  proc print data=RS028 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS028 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
