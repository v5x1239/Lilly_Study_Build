/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS105.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for missing ECGs
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : LABRSLTA
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
/*GLS105*/


/*Add code here*/

data GLS105_ (keep=SUBJID VISITNUM MERGE_DATETIME);
	set clntrial.SV_DUMP;
	if missing (VISITNUM) then VISITNUM=BLOCKID;
	if VISITNUM in (0,2,3,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,
	48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,
	822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,
	863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899);
run;
proc sql;
	create table GLS105_1 as
	select distinct SUBJID,BLOCKID, RQSTNTYP
	from clntrial.LABRSLTA
	where RQSTNTYP='ECG';
quit;

		
proc sql;
	create table GLS105 as
	select distinct a.MERGE_DATETIME , a.SUBJID, a.VISITNUM, b.BLOCKID, b.RQSTNTYP, 'Missing ECGs' as message
	from GLS105_ a left join GLS105_1 b
	on a.SUBJID=b.SUBJID and a.VISITNUM=b.BLOCKID
	where missing (b.RQSTNTYP) and datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID,VISITNUM ;
quit;

/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for missing ECGs";
  proc print data=GLS105 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS105 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
