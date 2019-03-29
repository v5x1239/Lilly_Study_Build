/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU_RS_700.sas
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

*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8X_MC_JECA;

proc sql;
	create table TU1 as select a.SUBJID, a.PAGE, TULNKINW as TULNKID, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001a as a left join clntrial.TU1001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINW eq b.TRLNKID
;
	create table TU2 as select a.SUBJID, a.PAGE, TULNKITG as TULNKID, TUDAT, TUCATREC as TUCAT,
	TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TRDAT,
	'TU2001' as Flag length=100
	from clntrial.TU2001a as a left join clntrial.TU2001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKITG eq b.TRLNKID
;

	create table TU3 as select a.SUBJID, a.PAGE,TULNKINT as TULINKID, TUDAT, TUCATREC as TUCAT,
	TRSPID, TRLNKID, TRMETHOD, TRMTHODO,TRDAT,
	'TU3001' as Flag length=100
	from clntrial.TU3001a as a left join clntrial.TU3001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINT eq b.TRLNKID
;

	create table TU7 as select a.SUBJID, a.PAGE, TULNKIMT as TULINKID, TUDAT, TUCATME as TUCAT,
	TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TRDAT,
	'TU7001' as Flag length=100
	from clntrial.TU7001a as a left join clntrial.TU7001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKIMT eq b.TRLNKID
;

	create table TU8 as select a.SUBJID,a.PAGE,TULNKINM as TULINKID,TUDAT, TUCATME as TUCAT,
	TRSPID, TRLNKID, TRMETHOD, TRMTHODO, TRDAT,
	'TU8001' as Flag length=100
	from clntrial.TU8001a as a left join clntrial.TU8001b as b
	on a.SUBJID eq b.SUBJID and a.TULNKINM eq b.TRLNKID
;
	/*create table TU1C as select a.SUBJID as SUBJID_, a.PAGE, TULNKINW as TULINKID, TUDAT, TRSPID, TRLNKID, TRDAT
	from clntrial.TU1001 as a
;*/
quit;

data TU;
	set TU1 TU2 TU3 TU7 TU8 /*TU1C*/; 
run;
proc sort;
by subjid;
run;
data rs1;
set clntrial.RS1001;
RSCAT = rscatrec;
keep SUBJID RSDAT RSSPID RSCAT OVRLRESP;
run;
proc sort;
by subjid;
run;
data rs2;
set clntrial.RS2001;
RSCAT = rscatmes;
keep SUBJID RSDAT RSSPID RSCAT OVRLRESP ;
run;
proc sort;
by subjid;
run;
data rs3;
set clntrial.IRRC1001;
RSCAT = rsctirrc;
keep SUBJID RSDAT RSSPID RSCAT IRRCRESP;
run;
proc sort;
by subjid;
run;
data rs;
set rs1 rs2 rs3;
by subjid;
run;
proc sort;
by subjid;
run;
data ds;
set clntrial.dS1001;
keep SUBJID DSSTDAT DSDECOD DTHDAT;
run;
proc sort;
by subjid;
run;
data sv;
set clntrial.SV1001;
keep SUBJID BLOCKID VISDAT;
run;
proc sort;
by subjid;
run;
data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;
data stat;
set clntrial.statonco;
keep stat subjid;
run;
Proc sort;
by subjid;
run;
data fin;
merge tu(in = a) stat rs ds sv dm;
by subjid;
if a;
run;
data TU_RS_700;
retain SITEMNEMONIC SUBJID BLOCKID VISDAT stat TULNKID TUDAT TUCAT TRSPID TRMETHOD TRMTHODO TRDAT
RSDAT RSSPID RSCAT OVRLRESP IRRCRESP DSSTDAT DSDECOD DTHDAT;
set fin;
keep SITEMNEMONIC SUBJID BLOCKID VISDAT TULNKID TUDAT TUCAT TRSPID TRMETHOD TRMTHODO TRDAT
RSDAT RSSPID RSCAT OVRLRESP IRRCRESP DSSTDAT DSDECOD DTHDAT stat;
run;



/*Print TU_RS_700*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Review Tumor, Response, and Study Disposition data";

  proc print data=TU_RS_700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU_RS_700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
