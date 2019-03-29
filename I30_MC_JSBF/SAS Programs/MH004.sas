/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Prem, use the below libame statment to call in the Clintrial raw datasets.*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I3O_MC_JSBF;*/

/*Prem, use the _all version of the raw dataset for programming*/



/* over lap */
proc sort data=clntrial.MH8001 out=MH(keep=/*merge_datetime SITEMNEMONIC*/ SUBJID 
	MHSPID MHTERM MHDECOD MHSTDAT MHENDAT);
	by /*SITEMNEMONIC*/ SUBJID MHTERM MHSTDAT;
	where MHSTDAT~=.;
run;
proc sort data = clntrial.DM1001C out = DM(keep = SITEMNEMONIC SUBJID);
	by subjid;
run;
data mer;
	merge mh(in = a) DM;
	by subjid;
	if a;
run;

data MH_;
	retain RECNUM .;
	set mer;
	by SUBJID MHTERM;
	if first.SUBJID then RECNUM = 1;
	else RECNUM = RECNUM + 1;
run;

proc sql;
create table MH__ as 
select a.*,b.sitemnemonic
from MH_ a left join clntrial.DM1001c b
	on a.SUBJID=b.SUBJID
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
order by b.SITEMNEMONIC, a.SUBJID
; 

create table MH004 as
select distinct /*A.merge_datetime,*/ A.SITEMNEMONIC, A.SUBJID, B.RECNUM,
	B.MHSPID, B.MHTERM, B.MHDECOD, B.MHSTDAT, B.MHENDAT
		from MH__ as A, MH__ as B
		where 	A.SITEMNEMONIC EQ B.SITEMNEMONIC and 
				A.SUBJID EQ B.SUBJID and 
				(A.RECNUM NE B.RECNUM) and 
				upcase(A.MHTERM) EQ upcase(B.MHTERM) and 
				((A.MHSTDAT >= B.MHSTDAT and A.MHSTDAT <= B.MHENDAT) or 
					(A.MHENDAT >= B.MHSTDAT and A.MHENDAT <= B.MHENDAT)) /*or 
					(A.MHSTDAT >= B.MHSTDAT and B.MHENDAT EQ .) or 
					(B.MHSTDAT >= A.MHSTDAT and A.MHENDAT EQ .))*/
		union
	select distinct /*A.merge_datetime,*/A.SITEMNEMONIC, A.SUBJID, A.RECNUM,
	A.MHSPID, A.MHTERM, A.MHDECOD, A.MHSTDAT, A.MHENDAT
		from MH__ as A, MH__ as B
		where 	A.SITEMNEMONIC EQ B.SITEMNEMONIC and 
				A.SUBJID EQ B.SUBJID and 
				(A.RECNUM NE B.RECNUM) and 
				upcase(A.MHTERM) EQ upcase(B.MHTERM) and 
				((A.MHSTDAT >= B.MHSTDAT and A.MHSTDAT <= B.MHENDAT) or 
					(A.MHENDAT >= B.MHSTDAT and A.MHENDAT <= B.MHENDAT)) /*or 
					(A.MHSTDAT >= B.MHSTDAT and B.MHENDAT EQ .) or 
					(B.MHSTDAT >= A.MHSTDAT and A.MHENDAT EQ .))*/
		order by SITEMNEMONIC, SUBJID, MHTERM;
quit;





/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print MH004*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Reported Event Term";
  title2 "No identical terms with duplicate and overlapping dates can be recorded";

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
