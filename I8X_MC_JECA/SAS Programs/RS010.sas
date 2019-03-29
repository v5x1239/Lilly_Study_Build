/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS010.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : Check for new Tumors and the Tumor State of the new Tumor is unequivocal.
									then overall reponse should be Progressive Disease
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

data RS;
	set clntrial.RS1001(rename=(RSCATREC=RSCAT)) clntrial.RS2001(rename=(RSCATMES=RSCAT)) clntrial.IRRC1001(rename=(RSCTIRRC=RSCAT IRRCRESP=OVRLRESP));
	where RSSPID ne .;
	keep SUBJID RSDAT RSSPID RSCAT BLOCKID BLOCKRPT OVRLRESP /*MERGE_DATETIME*/;
run;

proc sql;
	create table TU as select a.SUBJID as SUBJID_, TULNKINW as TULINKID, TUDAT, TRSPID, TUMIDENT as TUMSTATE_NEW, TRLNKID

	from clntrial.TU1001a as a left join clntrial.TU1001b as b

	on a.SUBJID eq b.SUBJID and a.TULNKINW eq b.TRLNKID;
quit;

proc sql;
	create table RS_TU as select a.*, b.*

	from RS as a left join TU as b

	on a.SUBJID eq b.SUBJID_ and a.RSSPID eq b.TRSPID 
;
quit;

proc sql;
	create table RS010 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SUBJID,
	datepart(RSDAT) as RSDAT format =date9.,
	RSSPID,
	OVRLRESP,
	RSCAT,
	TULINKID,
	datepart(TUDAT) as TUDAT format =date9.,
	TRSPID,
	TUMSTATE_NEW

	from RS_TU

	where strip(upcase(TUMSTATE_NEW)) eq 'UNEQUIVOCAL' and strip(upcase(OVRLRESP)) not in  ('PD', 'PROGRESSIVE DISEASE', 'IRPD', 'IRPROGRESSIVE DISEASE')
	/*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, RSDAT, RSSPID
;
quit;


/*Print RS010*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for new Tumors and the Tumor State of the new Tumor is unequivocal";
	title2 "then overall reponse should be Progressive Disease";

  proc print data=RS010 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS010 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
