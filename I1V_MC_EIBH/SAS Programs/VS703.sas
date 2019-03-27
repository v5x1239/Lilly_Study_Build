/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : VS703.sas
PROJECT NAME (required)           : I1V_MC_EIBH
DESCRIPTION (required)            : Check to ensure that all 3 measurements were recoreded within a visit for BP and Pulse
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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

data PRERF_Y(keep = SUBJID BLOCKID PAGE PAGERPT MERGE_DATETIME)
	 PEREF_N(Keep = SUBJID BLOCKID PAGE PAGERPT SYSBP DIABP PULSE VSSPID);
	set Clntrial.VS1001_all;
	if strip(VSPERF) eq 'Y' then output PRERF_Y;
	if strip(VSPERF) ne 'Y' then output PEREF_N;
run;

Proc Sql;
	Create Table VS703 as Select 
		strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,
		SUBJID,
		BLOCKID,
		VSSPID

		From

		(select X.*, Y.SYSBP, Y.DIABP, Y.PULSE, Y.VSSPID

			from 

			PRERF_Y as X left join PEREF_N as Y

			on X.SUBJID EQ Y.SUBJID and X.BLOCKID EQ Y.BLOCKID and X.PAGE EQ Y.PAGE

			and X.PAGERPT eq Y.PAGERPT)


		Group by SUBJID, BLOCKID

		Having(Count(VSSPID)) LT 3 and (input(MERGE_DATETIME,Date9.) > input("&date",Date9.))


		order by SUBJID, BLOCKID
;
Quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Check to ensure that all 3 measurements were recoreded within a visit for BP and Pulse";

proc print data=VS703 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set VS703 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

