/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : ONC_TU206_RS009_RS018_RS023_V1.sas
PROJECT NAME (required)           : I3Y-MC-JPBZ
DESCRIPTION (required)            : Summary of tumor and response data to ensure that data entered on the CRF aligns with the RECIST 1.1 response criteria. 
				    Version 1 of the report aligns with the initial study build template tumor and response forms including the following items:  
			            RSDAT, OVRLRESP_NRP, LDIAM, SAXIS.  .
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : ONC_TU206_RS009_RS018_RS023_V1.sql
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code
2.0  Deenadayalan     Updated per new spec "ONC_TU206_RS009_RS018_RS023_V1_Code Development Specifications_updated 14Jun2017"

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
proc sql;
	create table ONC_TU206_RS009_RS018_RS023_V1 as
	select STUDY,SITEMNEMONIC, SUBJID,TRSPID,RSSPID,TULNKID,TRPERF,case when not missing (TRDAT) then datepart(TRDAT) else . end as TRDAT format date9.,
	case when not missing (RSDAT) then datepart(RSDAT) else . end as RSDAT format date9.,
	TULOC,TULOCOTH,TRMETHOD,TRMETHODOTH,TUMSTATE,TRSTRESC,LDIAM,SAXIS,SUMDIAM,PCBSD,PCNSD,CRF_TRGRESP,CALC_TRGRESP,CRF_NTRGRESP,
	OVRLRESP_NRP,CRF_OVRRESP,NEWTUMOR,Error_Message from clntrial.ONC_V1
	where subjid in (select subjid from clntrial.ONC_V1 where not missing (Error_Message ))
	order by SUBJID,TRSPID,SOR,TRDAT,RSSPID;
quit;

/*Print AE015a*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Summary of tumor and response data to ensure";
  title2 "that data entered on the CRF aligns with the RECIST 1.1 ";

proc print data=ONC_TU206_RS009_RS018_RS023_V1 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set ONC_TU206_RS009_RS018_RS023_V1 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




