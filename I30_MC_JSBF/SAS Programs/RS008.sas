/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS008.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Date of Response Assessment must be equal to Date of Tumor Measurement with same assessment number in Tumor evaluation CRFs. If there is more than one tumor measurement date within that assessment, response date must be = to the later date of the tumor measurement.
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
proc sql;
create table RS as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, a.RSPERF, a.RSDAT, a.RSSPID
from clntrial.RS1001 a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
;
quit; 
proc sql;
create table TU_1 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, /*c.TULNKID,*/ c.TRSPID, c.TRDAT
from clntrial.TU1001a a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
	left join clntrial.TU1001b c
		on a.SUBJID=c.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, c.TRSPID, c.TRDAT
; 
quit; 
proc sql;
create table TU_2 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, /*c.TULNKID,*/ c.TRSPID, c.TRDAT
from clntrial.TU2001a a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
	left join clntrial.TU2001b c
		on a.SUBJID=c.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, c.TRSPID, c.TRDAT
; 
quit; 
proc sql;
create table TU_3 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, /*c.TULNKID,*/ c.TRSPID, c.TRDAT
from clntrial.TU3001a a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
	left join clntrial.TU3001b c
		on a.SUBJID=c.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, c.TRSPID, c.TRDAT
; 
quit;

data TU;
set TU_1 TU_2 TU_3;
run;

proc sql;
create table RS008 as 
select /*a.merge_datetime,*/ a.SITEMNEMONIC, a.SUBJID, a.RSPERF, a.RSDAT, a.RSSPID,
	/*b.TULNKID,*/ b.TRSPID, b.TRDAT
from RS a left join TU b
on a.SITEMNEMONIC=b.SITEMNEMONIC and 
	a.SUBJID=b.SUBJID and 
	a.RSSPID=b.TRSPID
where /*(datepart(a.merge_datetime) > input("&date", ? Date9.)) and*/  a.RSDAT~=b.TRDAT
order by a.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
; quit;



	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS008*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Date of Response Assessment";
title2 "Date of Response Assessment must be equal to Date of Tumor Measurement with same assessment number in Tumor evaluation CRFs.";
  proc print data=RS008 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS008 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
