/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR702.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Consent not received prior to on study procedures performed
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Add code here*/


data dt;
	attrib
	subjid_ length=8
	blockid_ length=$40
	page_ length=$40
	variable length=$40
	date length=8 format=date9.;
	if not missing (subjid_);
run;

%macro dsn (ds,dt); 
data dt_(keep=subjid_ blockid_ page_ date variable);
	length page_ variable blockid_ $40 subjid_ date 8  ;
	set clntrial.&ds. ;
	subjid_=subjid;
	blockid_=blockid;
	date=&dt.;
	page_=page;
	variable="&dt.";
run;
proc append base=dt data=dt_;
run;
%mend;
%dsn (SV1001, VISDAT);
%dsn (VS1001, VSDAT);
%dsn (EG3001, EGDAT);
%dsn (ECOG1001, ECGPSDT);
%dsn (MDALC100, MDALSTD);
%dsn (EQ5D5L10, EQ5D5DT);
%dsn (DS1001, DSSTDAT);
%dsn (DS1001, DTHDAT);
/*%dsn (DA1001, DADAT);*/
%dsn (EC1001, ECSTDAT);
%dsn (EC1001, ECENDAT);
%dsn (EX1001, EXSTDAT);
%dsn (EX1001, EXENDAT);
%dsn (EX1001, EXPTRTDAT);
%dsn (RS1001, RSDAT);
%dsn (SS1001, SSLSTKAD);
%dsn (SS1001, SSDAT);
%dsn (AE4001B, AESTDAT);
%dsn (AE4001B, AEENDAT);
%dsn (SAE2001A,SAEWDT);
%dsn (SAE2001A, SAESMDT);
%dsn (SAE2001B, SAEFUSMD);
%dsn (SAE2001B, SAEFUWD);
%dsn (CM1001, CMSTDAT);
%dsn (CM1001, CMENDAT);
%dsn (TRF3001,TRFSTDAT );
%dsn (IRAD3001, IRDSTDT);
%dsn (IRAD3001, IRDENDT);
%dsn (HO2001, HOSTDAT);
%dsn (HO2001, HOENDAT);
/*%dsn (SG1001, SGDAT);*/
%dsn (SYST3001, SYSTSTDT);
%dsn (SYST3001, SYSTENDT);
%dsn (TU1001A, TUDATE);
%dsn (TU1001A, TUDAT);
%dsn (TU1001B, TRDAT);
%dsn (TU2001A, TUDAT);
%dsn (TU2001B, TRDAT);
%dsn (TU3001A, TUDAT);
%dsn (TU3001B, TRDAT);

proc sql;
	create table MSR702 as
	select distinct a.MERGE_DATETIME,a.SUBJID, b.BLOCKID_, b.page_, a.DSSTDAT_IC, b.variable, b.date
	from clntrial.DS2001_D a left join dt b
	on a.SUBJID=b.SUBJID_
	where a.page='DS2001_LF1' and not missing (b.date) and not missing (a.DSSTDAT_IC) and
	b.date lt datepart (a.DSSTDAT_IC) and datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print MSR702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "DConsent not received prior to on study procedures performed";


  proc print data=MSR702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
