/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : VS011.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : Weight change from previous measurement must be within +/-20% and/or 10 kg and/or 20 lbs.
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : VS1001 SV1001
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

proc sort data=clntrial.VS_DUMP out=VS1001(keep = SUBJID BLOCKID WEIGHT WEIGHTU /*MERGE_DATETIME*/);
	by SUBJID BLOCKID;
	where not missing(WEIGHT);
run;

proc sort data=clntrial.SV1001 out=SV1001;
	by SUBJID BLOCKID;
run;

/* lb to kg Convertion*/
data VS_CN;
	set VS1001;
	if WEIGHTU eq 'LB' then do;
		WEIGHTU_KG = 'kg'; WEIGHT_KG = round(WEIGHT*0.45359237,0.01); end;
		else do; WEIGHT_KG = WEIGHT; WEIGHTU_KG = WEIGHTU; end;
run;

proc sort data=VS_CN; by SUBJID BLOCKID; run; 

data VS_SEQ;
	set VS_CN;
		by SUBJID BLOCKID;
		if first.SUBJID then SEQ = 1;
			else SEQ+1;
run;

proc sql;
	create table VS as select 
	/*strip(put(datepart(a.MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	a.SUBJID,
	a.BLOCKID,
	a.WEIGHT,
	a.WEIGHTU,
	a.WEIGHT_KG,
	a.WEIGHTU_KG,
	b.WEIGHT_KG as WEIGHT_PRE,
	(case
		when not missing(a.WEIGHT_KG) and not missing(b.WEIGHT_KG) and a.WEIGHT_KG GE b.WEIGHT_KG then a.WEIGHT_KG-b.WEIGHT_KG
		when not missing(a.WEIGHT_KG) and not missing(b.WEIGHT_KG) and a.WEIGHT_KG LT b.WEIGHT_KG then b.WEIGHT_KG-a.WEIGHT_KG
		else .
	end) as DIFEERENCE_KG,
	strip(put(datepart(VISDAT),date9.)) as VISDAT
			

	from VS_SEQ as a left join VS_SEQ as b

	on a.SUBJID eq b.SUBJID and a.SEQ eq (b.seq+1)

	left join SV1001 as c 

	on a.SUBJID eq c.SUBJID and a.blockid eq c.blockid

	order by SUBJID, BLOCKID
;
quit;

proc sql;
	create table VS011 as select *

	from VS

/*	where (input(MERGE_DATETIME,Date9.) > input("&date",Date9.))*/

	order by SUBJID, BLOCKID, VISDAT
;
quit;


/*Print VS011*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Weight change from previous measurement must be within +/-20% and/or 10 kg and/or 20 lbs";
title2 "During Lilly review - please provide values for this check";

  proc print data=VS011 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set VS011 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
