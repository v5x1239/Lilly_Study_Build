/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX005.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : For the same treatment name, consecutive entries must be detected across the CRF different from each other..
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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
	create table EX1001 as select
	SUBJID,
	BLOCKID,
	EXSPID,
	EXTPT,
	EXOCCUR,
	EXSTDAT,
	catx(":",ifc(EXSTTIMH not in ("","-99"),put(input(EXSTTIMH,best2.),z2.),' '),
	ifc(EXSTIMMI not in ("","-99"),put(input(EXSTIMMI,best2.),z2.),' ')) as EXSTTIM,
	case
	when EXSTDATY ne '' then 
 	input((cat(strip(EXSTDATY),   
	 ifc(EXSTDATM not in ("","-99"),'-'||put(input(left(EXSTDATM),best2.),z2.),'01' ),  
	 ifc(EXSTDATD not in ("","-99"),'-'||put(input(left(EXSTDATD),best2.),z2.),'01' ), 
	 ifc(EXSTTIMH not in ("","-99"),'T'||put(input(left(EXSTTIMH),best2.),z2.),'00' ), 
	 ifc(EXSTIMMI not in ("","-99"),':'||put(input(left(EXSTIMMI),best2.),z2.),'00' ),
	 '00')),is8601dt.) 
	else . 
	end as EXSTDTC

	from clntrial.EX1001

	where not missing (EXSPID) and strip(upcase(EXOCCUR)) in ('Y','YES') and strip(upcase(PAGE)) eq 'EX1001_ML1001_F1'

	order by SUBJID, EXSPID
;
quit;

data EX_SEQ;
	set EX1001;
	by SUBJID EXSPID EXSTDTC;
	PRE_EXSTDTC= lag(EXSTDTC);
	PRE_EXSTTIM= lag(EXSTTIM);
	if first.SUBJID then do; PRE_EXSTDTC=.; PRE_EXSTTIM =''; end; 
run;

proc Sql;
	Create table EX005 as Select
	/*strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,*/
	SUBJID,
	BLOCKID,
	EXSPID,
	EXTPT,
	EXOCCUR,
	EXSTDAT format = date9., 
	EXSTTIM,
	datepart(PRE_EXSTDTC) as PRE_EXSTDTC  format = date9., 
	PRE_EXSTTIM

	from EX_SEQ

	where EXSTDTC LE PRE_EXSTDTC /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, EXSPID
	
;
quit;



ods csv file=&irfilcsv trantab=ascii;
  title1 "For the same treatment name, consecutive";
	title2 "entries must be detected across the CRF";

proc print data=EX005 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX005 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
