/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC105A.sas
PROJECT NAME (required)           : I1V_MC_EIBH
DESCRIPTION (required)            : Check for GLS lab records without corresponding date of visit panel for the 
									same project investigator patient visit (PIPV).
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Sushil Kumar     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
data lbr lbru;
	set Clntrial.LABRSLTA;
	if not missing (UNSCHDLD) then output lbru;
	else output lbr;
run;

data sv svu;
	set Clntrial.SV1001;
	if not missing (UNVISTNM) then output svu;
	else output sv;
run;
	

Proc Sql;
	Create Table REC105A_1 as Select distinct		
		A.SUBJID,
		A.BLOCKID,
		a.UNSCHDLD,
		Datepart(A.CLLCTDT) as CLLCTDT format = date9.,
		B.BLOCKID as SV_BLOCKID,
		B.VISITNUM as SV_VISITNUM,
		b.UNVISTNM,
		Datepart(B.VISDAT) as VISDAT Format = date9.
		

		From lbr as A Left Join sv as B on

		A.SUBJID eq B.SUBJID and A.BLOCKID eq B.VISITNUM

		where input(Strip(substr(Strip(Put(A.CLLCTDT,datetime20.)),1,9)),date9.) NE 
				input(Strip(substr(Strip(Put(B.VISDAT,datetime20.)),1,9)),date9.);


	Create Table REC105A_2 as Select distinct
		A.SUBJID,
		A.BLOCKID,
		a.UNSCHDLD,
		Datepart(A.CLLCTDT) as CLLCTDT format = date9.,
		B.BLOCKID as SV_BLOCKID,
		B.VISITNUM as SV_VISITNUM,
		b.UNVISTNM,
		Datepart(B.VISDAT) as VISDAT Format = date9.
		

		From lbru as A Left Join svu as B on

		A.SUBJID eq B.SUBJID and A.BLOCKID eq B.VISITNUM

		where input(Strip(substr(Strip(Put(A.CLLCTDT,datetime20.)),1,9)),date9.) NE 
				input(Strip(substr(Strip(Put(B.VISDAT,datetime20.)),1,9)),date9.)
;
Quit;

data REC105A;
	set REC105A_1 REC105A_2;
run;
proc sort data=REC105A;
	by SUBJID BLOCKID;
run;


ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for GLS lab records without corresponding date of visit";
 title2 "panel for the same project investigator patient visit (PIPV).";

proc print data=REC105A noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set REC105A nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

