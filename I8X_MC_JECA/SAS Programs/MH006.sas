/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH006.sas
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


proc sql;
	create table MH as select /*MERGE_DATETIME,*/ SUBJID, MHSPID, MHTERM, MHDECOD, 
	datepart(MHSTDAT) as MHSTDAT, datepart(MHENDAT) as MHENDAT

	from clntrial.MH8001

	where not missing(MHDECOD)
;
	create table Ae as select a.SUBJID as SUBJID_, a.AEGRPID,  a.AETERM, a.AEDECOD, datepart(b.AESTDAT) as AESTDAT

	from clntrial.AE4001a as a left join clntrial.AE4001b as b

	on a.SUBJID eq b.SUBJID and a.AEGRPID eq b.AEGRPID
	
;
quit;
proc sql;
create table mh1 as select a.*,b.SITEMNEMONIC from mh as a left join clntrial.DM1001c as b

	on a.SUBJID eq b.SUBJID 
	
;
quit;


proc sql;
	create table MH_AE as select a.*, b.*,
	(case
		when not missing(AESTDAT) and not missing(MHENDAT) then AESTDAT-MHENDAT 
		else .
	end) as Day

	from MH1 as a left join AE as b

	on a.SUBJID eq b.SUBJID_ and strip(upcase(a.MHDECOD)) eq strip(upcase(b.AEDECOD))
;
quit;

proc sql;
	create table MH006 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SITEMNEMONIC,
	SUBJID,
	MHSPID,
	MHTERM,
	MHDECOD,
	MHSTDAT format =date9.,
	MHENDAT format =date9.,
	AEGRPID,
	AETERM, 
	AEDECOD, 
	AESTDAT format =date9.

	from MH_AE

	where Day ne . and Day gt 1 /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SITEMNEMONIC,SUBJID, MHSPID, MHDECOD, MHSTDAT, MHENDAT
;
quit;


/*Print MH006*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If identical term is entered in MH and AE forms,";
	title2 "AE start date must be more than 1 day after MH stop date ";

  proc print data=MH006 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH006 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
