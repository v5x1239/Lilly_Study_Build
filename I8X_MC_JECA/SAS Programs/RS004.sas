/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS004.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded.
									During Lilly review - please provide values for this check
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
	set clntrial.RS1001(rename=(RSCATREC=RSCAT)) clntrial.RS2001(rename=(RSCATMES=RSCAT)) clntrial.IRRC1001(rename=(RSCTIRRC=RSCAT));
	where RSSPID ne .;
	keep SUBJID RSPERF RSDAT RSSPID RSCAT BLOCKID BLOCKRPT;
run;

proc sql;
	create table RS_SV as select /*MERGE_DATETIME,*/ a.SUBJID, RSPERF, RSSPID, RSCAT,
	datepart(RSDAT) as RSDAT, a.BLOCKID, a.BLOCKRPT, b.VISITNUM

	from RS as a left join clntrial.SV1001 as b

	on a.SUBJID eq b.SUBJID and a.BLOCKID eq b.BLOCKID and a.BLOCKRPT eq b.BLOCKRPT

	order by SUBJID, RSDAT, VISITNUM, BLOCKID, BLOCKRPT	
;
quit;

data RS_SEQ;
	set RS_SV;
		by  SUBJID RSDAT VISITNUM BLOCKID BLOCKRPT;
		 if first.SUBJID then SEQ=1;
		 	else SEQ+1;
run;

proc sql;
	create table RS004 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SUBJID,
	RSPERF,
	RSDAT format =date9.,
	RSSPID,
	RSCAT
	
	from RS_SEQ

	where RSSPID ne SEQ /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, RSDAT, RSSPID
;
quit;


/*Print RS004*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure "assessment number within visit" are sequential for multiple assessments performed.";

  proc print data=RS004 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS004 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
