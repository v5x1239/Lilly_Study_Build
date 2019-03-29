/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU201.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : Ensure there is a response for every assessment and sequences are logical per response criteria.
									
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

proc sql;
	/*create table TU1 as select a.*, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001a as a left join clntrial.TU1001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINW eq b.TRLNKID
;*/
	create table TU2 as select a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.PAGE, a.PAGERPT, TULNKITG as TULNKID, TULOC, TULOCOTH, TUMIDENT, TUDAT, TUCATREC as TUCAT,
	TRPERF, TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TUMSTATE, TRSTRESC, LDIAM, LDIAMU, SAXIS, SAXISU, TRDAT,
	'Listing #1: TU2001' as Flag length=100
	from clntrial.TU2001a as a left join clntrial.TU2001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKITG eq b.TRLNKID
;

	create table TU3 as select a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.PAGE, a.PAGERPT, TULNKINT as TULINKID, TULOC, TULOCOTH, TUMIDENT, TUDAT, TUCATREC as TUCAT,
	TRPERF, TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TUMSTATE, TRDAT,
	'Listing #2: TU3001' as Flag length=100
	from clntrial.TU3001a as a left join clntrial.TU3001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINT eq b.TRLNKID
;

	create table TU7 as select a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.PAGE, a.PAGERPT, TULNKIMT as TULINKID, TULOC, TULOCOTH, TUMIDENT, TUDAT, TUCATME as TUCAT,
	TRPERF, TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TUMSTATE, TRSTRESC, LDIAM, LDIAMU, SAXIS, SAXISU, LPERP, LPERPU, IMGSQMTH, TRDAT,
	'Listing #3: TU7001' as Flag length=100
	from clntrial.TU7001a as a left join clntrial.TU7001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKIMT eq b.TRLNKID
;

	create table TU8 as select a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.PAGE, a.PAGERPT, TULNKINM as TULINKID, TULOC, TULOCOTH, TUMIDENT, TUDAT, TUCATME as TUCAT,
	TRPERF, TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TUMSTATE, TRDAT,
	'Listing #4: TU8001' as Flag length=100
	from clntrial.TU8001a as a left join clntrial.TU8001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINM eq b.TRLNKID
;
	/*create table TU1C as select a.SUBJID as SUBJID_, a.PAGE, TULNKINW as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001 as a
;*/
quit;

data TU201;
	set /*TU1*/ TU2 TU3 TU7 TU8 /*TU1C*/; 
run;


/*Print TU201*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure tumor number is present and unique within baseline assessment.";

  proc print data=TU201 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU201 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
