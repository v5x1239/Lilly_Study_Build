/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded.
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required � study specific data verification report
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

proc sort data=clntrial.MH8001 out= MH8001;
	by SUBJID BLOCKID BLOCKRPT;
	where not missing(MHDECOD);
run;

proc sql;
	create table MH as select /*MERGE_DATETIME,*/ SUBJID, MHSPID, MHTERM, MHDECOD, 
	datepart(MHSTDAT) as MHSTDAT, datepart(MHENDAT) as MHENDAT

	from MH8001

	group by SUBJID, MHDECOD

	having count(MHDECOD) GE 2
;
quit;

proc sort data=MH;
	by SUBJID MHSPID MHDECOD MHSTDAT MHENDAT;
run;

data MH_SEQ;
	set MH;
		by  SUBJID MHSPID MHDECOD MHSTDAT MHENDAT;
		 if first.SUBJID then SEQ=1;
		 	else SEQ+1;
run;

proc sql;
	create table MH_LAP as select a.*, b.MHSTDAT as MHST, b.MHENDAT as MHED,
	(case
		when a.MHSTDAT between b.MHSTDAT and b.MHENDAT then 1
		else .
	end) as Flag

	from MH_SEQ as a left join MH_SEQ as b

	on a.SUBJID eq b.SUBJID and a.MHDECOD eq b.MHDECOD and a.SEQ eq (b.seq+1)
;
quit;

proc sql;
	create table MH004 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SUBJID,
	MHSPID,
	MHTERM,
	MHDECOD,
	MHSTDAT format =date9.,
	MHENDAT format =date9.

	from MH_LAP

	where Flag eq 1 /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, MHSPID, MHDECOD, MHSTDAT, MHENDAT
;
quit;


/*Print MH004*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "No identical terms with duplicate and overlapping dates can be recorded";

  proc print data=MH004 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH004 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
