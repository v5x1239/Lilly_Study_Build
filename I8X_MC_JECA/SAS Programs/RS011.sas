/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS011.sas
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


/**** Listing 1 ****/
data RS;
	set clntrial.RS1001(rename=(RSCATREC=RSCAT)) clntrial.IRRC1001(rename=(RSCTIRRC=RSCAT IRRCRESP=OVRLRESP));
	where RSSPID ne .;
	keep SUBJID RSDAT RSSPID RSCAT BLOCKID BLOCKRPT OVRLRESP /*MERGE_DATETIME*/;
run;

proc sql;
	create table TU1 as select a.SUBJID as SUBJID_, TULNKINW as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001a as a left join clntrial.TU1001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINW eq b.TRLNKID
;

	create table TU2 as select a.SUBJID as SUBJID_, TULNKITG as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU2001a as a left join clntrial.TU2001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKITG eq b.TRLNKID
;

	create table TU3 as select a.SUBJID as SUBJID_, TULNKINT as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU3001a as a left join clntrial.TU3001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINT eq b.TRLNKID
;
quit;

data TU_ALL;
	set TU1 TU2 TU3;
run;

proc sql;
	create table RS_TU as select a.*, b.*

	from RS as a full join TU_ALL as b

	on a.SUBJID eq b.SUBJID_ and a.RSSPID eq b.TRSPID 
;
quit;

/*** Listing 2****/
data RS2_F1 RS2_F2;
	set clntrial.RS2001(rename=(RSCATMES=RSCAT));
	if RSSPID ne . and strip(upcase(PAGE)) eq 'RS2001_F1' then output RS2_F1;
	if RSSPID ne . and strip(upcase(PAGE)) eq 'RS2001_F2' then output RS2_F2;
	keep SUBJID RSDAT RSSPID RSCAT BLOCKID BLOCKRPT OVRLRESP /*MERGE_DATETIME*/;
run;

proc sql;
	create table TU7 as select a.SUBJID as SUBJID_, a.PAGE, TULNKIMT as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU7001a as a left join clntrial.TU7001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKIMT eq b.TRLNKID
;

	create table TU8 as select a.SUBJID as SUBJID_, a.PAGE, TULNKINM as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU8001a as a left join clntrial.TU8001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINM eq b.TRLNKID
;

	create table TU1C as select a.SUBJID as SUBJID_, a.PAGE, TULNKINW as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001 as a
;
quit;

data TULF1 TULF2;
	set TU1C TU7 TU8;
	if TRSPID ne . and strip(upcase(PAGE)) in ('TU7001_LF1', 'TU7001_LF1', 'TU1001_C1LF1') then output TULF1;
	if TRSPID ne . and strip(upcase(PAGE)) in ('TU7001_LF2', 'TU7001_LF2', 'TU1001_C2LF1') then output TULF2;
run;

/*** Listing 2****/
proc sql;
	create table RS_TULF1 as select a.*, b.*

	from RS2_F1 as a full join TULF1 as b

	on a.SUBJID eq b.SUBJID_ and a.RSSPID eq b.TRSPID 
;
quit;

/*** Listing 3****/
proc sql;
	create table RS_TULF2 as select a.*, b.*

	from RS2_F2 as a full join TULF2 as b

	on a.SUBJID eq b.SUBJID_ and a.RSSPID eq b.TRSPID 
;
quit;

/**** Appending All Three Listings ****/
data RS_FINAL;
	length Flag $200;
	set RS_TU(in=a) RS_TULF1(in=b) RS_TULF2(in=c);
	if A then Flag = 'Listing RS1001/IRRC1001 Comapre TU1001_LF1, TU2001, TU3001';
	else if B then  Flag = 'Listing#2 "RANO": Compare RS2001_F1 to TU7001_LF1, TU8001_LF1, and TU1001_C1LF1';
	else if C then  Flag = 'Listing #3 "CHESON": Compare RS2001_F2 to TU7001_F2, TU8001_F2, and TU1001_C2LF1'; 
run;

/** Final Report **/
proc sql;
	create table RS011 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	coalesce(SUBJID,SUBJID_) as SUBJID,
	datepart(RSDAT) as RSDAT format =date9.,
	RSSPID,
	OVRLRESP,
	TULINKID,
	TRSPID,
	datepart(TUDAT) as TUDAT format =date9.,
	FLAG

	from RS_FINAL

	where not missing(TRSPID) and missing(RSSPID) /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, RSDAT, RSSPID
;
quit;


/*Print RS011*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure there is a response for every assessment and sequences";
	title2 "are logical per response criteria";

  proc print data=RS011 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS011 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
